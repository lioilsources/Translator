package backend

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"strings"
)

// ClonePrefix marks a voice from the user's own library.
const ClonePrefix = "clone:"

// CloneTTS speaks cloned voices through the voice worker and everything else
// through Next. A failed clone falls back to the language's default voice, so
// the listener still hears the translation.
type CloneTTS struct {
	BaseURL string
	HTTP    *http.Client
	Next    TTS
	Default map[string]string
	Logger  *slog.Logger
}

// Format implements TTS. The voice worker and Next both produce WAV.
func (c *CloneTTS) Format() string { return c.Next.Format() }

// Synthesize implements TTS.
func (c *CloneTTS) Synthesize(ctx context.Context, r TTSRequest) ([]byte, error) {
	voice, cloned := strings.CutPrefix(r.Voice, ClonePrefix)
	if !cloned {
		return c.Next.Synthesize(ctx, r)
	}
	audio, err := c.clone(ctx, r, voice)
	if err == nil {
		return audio, nil
	}
	if ctx.Err() != nil {
		return nil, err
	}
	c.Logger.Warn("cloned voice failed, using default", "err", err, "lang", r.Language)
	r.Voice = c.Default[r.Language]
	return c.Next.Synthesize(ctx, r)
}

func (c *CloneTTS) clone(ctx context.Context, r TTSRequest, voice string) ([]byte, error) {
	body, err := json.Marshal(map[string]string{
		"device": r.Device, "voice": voice, "text": r.Text, "language": r.Language,
	})
	if err != nil {
		return nil, fmt.Errorf("clone encode: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		strings.TrimRight(c.BaseURL, "/")+"/v1/synthesize", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("clone request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, fmt.Errorf("clone call: %w", err)
	}
	defer resp.Body.Close()
	if err := checkStatus("clone", resp); err != nil {
		return nil, err
	}
	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("clone read: %w", err)
	}
	if len(data) == 0 {
		return nil, errors.New("clone: empty audio")
	}
	return data, nil
}
