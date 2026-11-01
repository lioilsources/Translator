package backend

import (
	"context"
	"encoding/json"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"testing"
)

type stubTTS struct{ got TTSRequest }

func (s *stubTTS) Format() string { return "wav" }
func (s *stubTTS) Synthesize(_ context.Context, r TTSRequest) ([]byte, error) {
	s.got = r
	return []byte("default"), nil
}

func cloneClient(t *testing.T, h http.HandlerFunc) (*CloneTTS, *stubTTS) {
	t.Helper()
	srv := httptest.NewServer(h)
	t.Cleanup(srv.Close)
	next := &stubTTS{}
	return &CloneTTS{
		BaseURL: srv.URL, HTTP: srv.Client(), Next: next,
		Default: map[string]string{"en": "kokoro:af_heart"},
		Logger:  slog.New(slog.NewTextHandler(io.Discard, nil)),
	}, next
}

func TestCloneRoutesToWorkerWithDevice(t *testing.T) {
	var got map[string]string
	c, _ := cloneClient(t, func(w http.ResponseWriter, r *http.Request) {
		_ = json.NewDecoder(r.Body).Decode(&got)
		_, _ = w.Write([]byte("RIFF"))
	})
	audio, err := c.Synthesize(context.Background(),
		TTSRequest{Text: "Hi", Language: "en", Voice: "clone:abc", Device: "dev"})
	if err != nil || string(audio) != "RIFF" {
		t.Fatalf("%q %v", audio, err)
	}
	if got["voice"] != "abc" || got["device"] != "dev" {
		t.Errorf("%v", got)
	}
}

func TestCloneFailureFallsBackToDefaultVoice(t *testing.T) {
	c, next := cloneClient(t, func(w http.ResponseWriter, _ *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	})
	audio, err := c.Synthesize(context.Background(), TTSRequest{Text: "Hi", Language: "en", Voice: "clone:abc"})
	if err != nil || string(audio) != "default" || next.got.Voice != "kokoro:af_heart" {
		t.Fatalf("%q %v %+v", audio, err, next.got)
	}
}

func TestOrdinaryVoiceSkipsWorker(t *testing.T) {
	c, next := cloneClient(t, func(http.ResponseWriter, *http.Request) { t.Error("worker called") })
	if _, err := c.Synthesize(context.Background(), TTSRequest{Text: "Hi", Language: "en", Voice: "kokoro:af_heart"}); err != nil {
		t.Fatal(err)
	}
	if next.got.Voice != "kokoro:af_heart" {
		t.Errorf("%+v", next.got)
	}
}
