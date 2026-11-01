package backend

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"mime/multipart"
	"net/http"
	"strings"
)

// kokoroLanguages maps our language codes to the codes Kokoro expects.
var kokoroLanguages = map[string]string{
	"en": "en-us", "es": "es", "fr": "fr-fr", "it": "it", "pt": "pt-br", "ja": "ja", "zh": "cmn", "hi": "hi",
}

// DirectTTSClient calls the /synthesize endpoint of the CPU audio runtime. It
// skips the job queue of the audio service, which polls once a second.
type DirectTTSClient struct {
	BaseURL string
	HTTP    *http.Client
}

// Format implements TTS.
func (c *DirectTTSClient) Format() string { return "wav" }

// directRequest resolves an "engine:voice" name into the runtime's request.
func directRequest(r TTSRequest) (map[string]any, error) {
	engine, voice, ok := strings.Cut(r.Voice, ":")
	if !ok || voice == "" {
		return nil, fmt.Errorf("tts: no voice for %q", r.Language)
	}
	switch engine {
	case "piper":
		_, name, ok := strings.Cut(voice, "-")
		if !ok {
			return nil, fmt.Errorf("tts: bad piper voice %q", voice)
		}
		return map[string]any{
			"text": r.Text, "language": r.Language, "voice": voice,
			"model": "piper-" + r.Language + "-" + name,
		}, nil
	case "kokoro":
		lang, ok := kokoroLanguages[r.Language]
		if !ok {
			return nil, fmt.Errorf("tts: kokoro has no language %q", r.Language)
		}
		return map[string]any{"text": r.Text, "language": lang, "voice": voice, "model": "kokoro-82m"}, nil
	}
	return nil, fmt.Errorf("tts: unknown engine %q", engine)
}

// Synthesize implements TTS.
func (c *DirectTTSClient) Synthesize(ctx context.Context, r TTSRequest) ([]byte, error) {
	payload, err := directRequest(r)
	if err != nil {
		return nil, err
	}
	encoded, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("tts encode: %w", err)
	}
	var body bytes.Buffer
	form := multipart.NewWriter(&body)
	if err := form.WriteField("request", string(encoded)); err != nil {
		return nil, fmt.Errorf("tts form: %w", err)
	}
	if err := form.Close(); err != nil {
		return nil, fmt.Errorf("tts form: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		strings.TrimRight(c.BaseURL, "/")+"/synthesize", &body)
	if err != nil {
		return nil, fmt.Errorf("tts request: %w", err)
	}
	req.Header.Set("Content-Type", form.FormDataContentType())
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return nil, fmt.Errorf("tts call: %w", err)
	}
	defer resp.Body.Close()
	if err := checkStatus("tts", resp); err != nil {
		return nil, err
	}
	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("tts read: %w", err)
	}
	if len(data) == 0 {
		return nil, errors.New("tts: empty audio")
	}
	return data, nil
}
