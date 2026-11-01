package backend

import (
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestDirectTTSResolvesVoices(t *testing.T) {
	var got map[string]any
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/synthesize" {
			t.Errorf("path %s", r.URL.Path)
		}
		if err := json.Unmarshal([]byte(r.FormValue("request")), &got); err != nil {
			t.Error(err)
		}
		_, _ = w.Write([]byte("RIFF"))
	}))
	defer srv.Close()
	c := &DirectTTSClient{BaseURL: srv.URL, HTTP: srv.Client()}

	cases := []struct{ voice, lang, model, wantLang string }{
		{"piper:cs_CZ-kasandra-medium", "cs", "piper-cs-kasandra-medium", "cs"},
		{"kokoro:af_heart", "en", "kokoro-82m", "en-us"},
	}
	for _, tc := range cases {
		audio, err := c.Synthesize(context.Background(), TTSRequest{Text: "x", Language: tc.lang, Voice: tc.voice})
		if err != nil || string(audio) != "RIFF" {
			t.Fatalf("%s: %q %v", tc.voice, audio, err)
		}
		if got["model"] != tc.model || got["language"] != tc.wantLang {
			t.Errorf("%s: %v", tc.voice, got)
		}
	}
}

func TestDirectTTSWithoutVoiceFails(t *testing.T) {
	c := &DirectTTSClient{BaseURL: "http://unused", HTTP: http.DefaultClient}
	if _, err := c.Synthesize(context.Background(), TTSRequest{Text: "x", Language: "de"}); err == nil {
		t.Fatal("expected error, the session then stays text-only")
	}
}
