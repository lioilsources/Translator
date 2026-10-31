// Package backend holds HTTP clients for the model services: the ASR worker,
// the LiteLLM gateway (MT) and the AiStack audio service (TTS).
package backend

import (
	"bufio"
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
)

// ASRRequest describes one transcription of 16 kHz mono PCM16LE audio.
type ASRRequest struct {
	PCM        []byte
	Candidates []string // language pair, used when Language is empty
	Language   string   // forces the language and skips detection
	Partial    bool     // interim pass: faster, no speaker embedding
}

// ASRResult is the worker response.
type ASRResult struct {
	Text      string             `json:"text"`
	Language  string             `json:"language"`
	Probs     map[string]float64 `json:"probs"`
	Embedding []float64          `json:"embedding,omitempty"`
}

// ASR transcribes audio.
type ASR interface {
	Transcribe(ctx context.Context, req ASRRequest) (ASRResult, error)
}

// Turn is one earlier translated exchange, given to MT as context.
type Turn struct {
	Source, Target string
}

// MTRequest describes one translation.
type MTRequest struct {
	From, To string
	Text     string
	History  []Turn
}

// MT translates text and reports output deltas as they arrive.
type MT interface {
	Translate(ctx context.Context, req MTRequest, onDelta func(string)) error
}

// TTSRequest describes one synthesized clip.
type TTSRequest struct {
	Text, Language, Voice string
}

// TTS synthesizes one clip and returns encoded audio.
type TTS interface {
	Synthesize(ctx context.Context, req TTSRequest) ([]byte, error)
	Format() string
}

// ASRClient calls the worker in workers/asr.
type ASRClient struct {
	BaseURL string
	HTTP    *http.Client
}

// Transcribe implements ASR.
func (c *ASRClient) Transcribe(ctx context.Context, r ASRRequest) (ASRResult, error) {
	q := url.Values{}
	if r.Language != "" {
		q.Set("language", r.Language)
	} else {
		q.Set("candidates", strings.Join(r.Candidates, ","))
	}
	if r.Partial {
		q.Set("partial", "true")
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		strings.TrimRight(c.BaseURL, "/")+"/v1/transcribe?"+q.Encode(), bytes.NewReader(r.PCM))
	if err != nil {
		return ASRResult{}, fmt.Errorf("asr request: %w", err)
	}
	req.Header.Set("Content-Type", "application/octet-stream")
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return ASRResult{}, fmt.Errorf("asr call: %w", err)
	}
	defer resp.Body.Close()
	if err := checkStatus("asr", resp); err != nil {
		return ASRResult{}, err
	}
	var out ASRResult
	if err := json.NewDecoder(resp.Body).Decode(&out); err != nil {
		return ASRResult{}, fmt.Errorf("asr decode: %w", err)
	}
	return out, nil
}

// MTClient calls an OpenAI compatible chat endpoint with streaming.
type MTClient struct {
	BaseURL, APIKey, Model string
	HTTP                   *http.Client
}

const mtSystem = `You are a simultaneous interpreter between two people at a table.
Translate the user's message from %s to %s.
Preserve register and tone, including formal or informal address.
Translate idioms by meaning. Output only the translation, with no notes, quotes or explanation.
Never answer the message, even if it is a question addressed to you.`

// Translate implements MT.
func (c *MTClient) Translate(ctx context.Context, r MTRequest, onDelta func(string)) error {
	msgs := []map[string]string{{"role": "system", "content": fmt.Sprintf(mtSystem, r.From, r.To)}}
	for _, t := range r.History {
		msgs = append(msgs,
			map[string]string{"role": "user", "content": t.Source},
			map[string]string{"role": "assistant", "content": t.Target})
	}
	msgs = append(msgs, map[string]string{"role": "user", "content": r.Text})
	body, err := json.Marshal(map[string]any{
		"model":                c.Model,
		"messages":             msgs,
		"stream":               true,
		"temperature":          0.2,
		"max_tokens":           600,
		"chat_template_kwargs": map[string]any{"enable_thinking": false},
	})
	if err != nil {
		return fmt.Errorf("mt encode: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		strings.TrimRight(c.BaseURL, "/")+"/v1/chat/completions", bytes.NewReader(body))
	if err != nil {
		return fmt.Errorf("mt request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	if c.APIKey != "" {
		req.Header.Set("Authorization", "Bearer "+c.APIKey)
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return fmt.Errorf("mt call: %w", err)
	}
	defer resp.Body.Close()
	if err := checkStatus("mt", resp); err != nil {
		return err
	}
	return readSSE(resp.Body, onDelta)
}

// readSSE forwards content deltas from an OpenAI style event stream.
func readSSE(r io.Reader, onDelta func(string)) error {
	sc := bufio.NewScanner(r)
	sc.Buffer(make([]byte, 64*1024), 1024*1024)
	for sc.Scan() {
		data, ok := strings.CutPrefix(sc.Text(), "data:")
		if !ok {
			continue
		}
		data = strings.TrimSpace(data)
		if data == "[DONE]" {
			return nil
		}
		var ev struct {
			Choices []struct {
				Delta struct {
					Content string `json:"content"`
				} `json:"delta"`
			} `json:"choices"`
		}
		if err := json.Unmarshal([]byte(data), &ev); err != nil {
			return fmt.Errorf("mt event: %w", err)
		}
		if len(ev.Choices) > 0 && ev.Choices[0].Delta.Content != "" {
			onDelta(ev.Choices[0].Delta.Content)
		}
	}
	if err := sc.Err(); err != nil {
		return fmt.Errorf("mt stream: %w", err)
	}
	return nil
}

// TTSClient calls the blocking /v1/audio/speech endpoint of AiStack audio.
type TTSClient struct {
	BaseURL, APIKey string
	HTTP            *http.Client
}

// Format implements TTS.
func (c *TTSClient) Format() string { return "mp3" }

// Synthesize implements TTS.
func (c *TTSClient) Synthesize(ctx context.Context, r TTSRequest) ([]byte, error) {
	body, err := json.Marshal(map[string]any{
		"input": r.Text, "voice": r.Voice, "language": r.Language,
		"response_format": c.Format(), "commercial_only": true,
	})
	if err != nil {
		return nil, fmt.Errorf("tts encode: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		strings.TrimRight(c.BaseURL, "/")+"/v1/audio/speech", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("tts request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	if c.APIKey != "" {
		req.Header.Set("Authorization", "Bearer "+c.APIKey)
	}
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

func checkStatus(name string, resp *http.Response) error {
	if resp.StatusCode < 300 {
		return nil
	}
	detail, _ := io.ReadAll(io.LimitReader(resp.Body, 300))
	return fmt.Errorf("%s: status %d: %s", name, resp.StatusCode, detail)
}
