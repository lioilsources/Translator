package backend

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func TestASRClientQueryAndDecode(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Query().Get("candidates") != "cs,en" {
			t.Errorf("query: %s", r.URL.RawQuery)
		}
		body, _ := io.ReadAll(r.Body)
		if len(body) != 4 {
			t.Errorf("body: %d", len(body))
		}
		fmt.Fprint(w, `{"text":"ahoj","language":"cs","probs":{"cs":0.9,"en":0.1}}`)
	}))
	defer srv.Close()
	c := &ASRClient{BaseURL: srv.URL, HTTP: srv.Client()}
	res, err := c.Transcribe(context.Background(), ASRRequest{PCM: make([]byte, 4), Candidates: []string{"cs", "en"}})
	if err != nil || res.Text != "ahoj" || res.Probs["cs"] != 0.9 {
		t.Fatalf("%+v %v", res, err)
	}
}

func TestMTClientStreamsAndSendsHistory(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var body struct {
			Model    string              `json:"model"`
			Stream   bool                `json:"stream"`
			Messages []map[string]string `json:"messages"`
		}
		_ = json.NewDecoder(r.Body).Decode(&body)
		if r.Header.Get("Authorization") != "Bearer k" || !body.Stream || body.Model != "m" || len(body.Messages) != 4 {
			t.Errorf("%+v", body)
		}
		fmt.Fprint(w, "data: {\"choices\":[{\"delta\":{\"role\":\"assistant\"}}]}\n\n")
		fmt.Fprint(w, "data: {\"choices\":[{\"delta\":{\"content\":\"Hel\"}}]}\n\n: keepalive\n\n")
		fmt.Fprint(w, "data: {\"choices\":[{\"delta\":{\"content\":\"lo\"}}]}\n\ndata: [DONE]\n\n")
	}))
	defer srv.Close()
	c := &MTClient{BaseURL: srv.URL, APIKey: "k", Model: "m", HTTP: srv.Client()}
	var got strings.Builder
	err := c.Translate(context.Background(), MTRequest{
		From: "cs", To: "en", Text: "Ahoj", History: []Turn{{"a", "b"}},
	}, func(d string) { got.WriteString(d) })
	if err != nil || got.String() != "Hello" {
		t.Fatalf("%q %v", got.String(), err)
	}
}

func TestTTSClientSurfacesServiceDown(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		http.Error(w, "engine down", http.StatusServiceUnavailable)
	}))
	defer srv.Close()
	c := &TTSClient{BaseURL: srv.URL, HTTP: srv.Client()}
	if _, err := c.Synthesize(context.Background(), TTSRequest{Text: "x"}); err == nil || !strings.Contains(err.Error(), "503") {
		t.Fatalf("%v", err)
	}
}
