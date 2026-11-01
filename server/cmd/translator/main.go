// Command translator is the conversation orchestrator.
package main

import (
	"context"
	"errors"
	"fmt"
	"log/slog"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"syscall"
	"time"

	"translator/server/internal/backend"
	"translator/server/internal/health"
	"translator/server/internal/session"
	"translator/server/internal/ws"
)

// Commercially clean default per language. Anything else is left to the audio
// service's own routing, which may need a GPU engine and then fails as text-only.
var defaultVoices = map[string]string{
	"cs": "piper:cs_CZ-kasandra-medium",
	"en": "kokoro:af_heart",
	"es": "kokoro:ef_dora",
	"fr": "kokoro:ff_siwis",
	"it": "kokoro:if_sara",
	"pt": "kokoro:pf_dora",
	"ja": "kokoro:jf_alpha",
	"zh": "kokoro:zf_xiaobei",
	"hi": "kokoro:hf_alpha",
}

// maxRecording is a little over 60 s of 16 kHz PCM16.
const maxRecording = 2 << 20

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	if err := run(logger); err != nil {
		logger.Error("fatal", "err", err)
		os.Exit(1)
	}
}

func env(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func envInt(key string, fallback int) (int, error) {
	v := os.Getenv(key)
	if v == "" {
		return fallback, nil
	}
	n, err := strconv.Atoi(v)
	if err != nil || n < 1 {
		return 0, fmt.Errorf("%s must be a positive integer", key)
	}
	return n, nil
}

func healthProbes(ttsURL, voiceURL string) []health.Probe {
	probes := []health.Probe{
		{Name: "asr", URL: env("ASR_URL", "http://localhost:8110") + "/health", Required: true},
		{Name: "mt", URL: env("MT_URL", "http://localhost:8080") + "/v1/models", Bearer: os.Getenv("MT_API_KEY"), Required: true},
		{Name: "tts", URL: ttsURL + "/health", Required: true},
	}
	if voiceURL != "" {
		probes = append(probes, health.Probe{Name: "voice", URL: voiceURL + "/health"})
	}
	return probes
}

// voiceLibrary forwards the library API, behind the token, to the voice worker.
// /v1/synthesize stays private because only /v1/voices is routed.
func voiceLibrary(target string, h *ws.Handler) (http.Handler, error) {
	u, err := url.Parse(target)
	if err != nil {
		return nil, fmt.Errorf("VOICE_URL: %w", err)
	}
	proxy := httputil.NewSingleHostReverseProxy(u)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if !h.Authorized(r) {
			http.Error(w, "unauthorized", http.StatusUnauthorized)
			return
		}
		r.Body = http.MaxBytesReader(w, r.Body, maxRecording)
		proxy.ServeHTTP(w, r)
	}), nil
}

func run(logger *slog.Logger) error {
	token := os.Getenv("TRANSLATOR_TOKEN")
	if token == "" && os.Getenv("TRANSLATOR_ALLOW_ANON") != "1" {
		return errors.New("set TRANSLATOR_TOKEN, or TRANSLATOR_ALLOW_ANON=1 for local development")
	}
	maxSessions, err := envInt("TRANSLATOR_MAX_SESSIONS", 8)
	if err != nil {
		return err
	}
	asrSlots, err := envInt("ASR_CONCURRENCY", 2)
	if err != nil {
		return err
	}
	mtSlots, err := envInt("MT_CONCURRENCY", 5)
	if err != nil {
		return err
	}
	ttsSlots, err := envInt("TTS_CONCURRENCY", 3)
	if err != nil {
		return err
	}
	httpc := &http.Client{}
	ttsURL := env("TTS_URL", "http://localhost:8093")
	var tts backend.TTS = &backend.TTSClient{BaseURL: ttsURL, APIKey: os.Getenv("TTS_API_KEY"), HTTP: httpc}
	if os.Getenv("TTS_MODE") == "direct" {
		tts = &backend.DirectTTSClient{BaseURL: ttsURL, HTTP: httpc}
	}
	voiceURL := os.Getenv("VOICE_URL")
	if voiceURL != "" {
		tts = &backend.CloneTTS{BaseURL: voiceURL, HTTP: httpc, Next: tts, Default: defaultVoices, Logger: logger}
	}
	h := &ws.Handler{
		Token: token, MaxSessions: int32(maxSessions), IdleTimeout: 30 * time.Minute, Logger: logger,
		Deps: session.Deps{
			ASR: &backend.ASRClient{BaseURL: env("ASR_URL", "http://localhost:8110"), HTTP: httpc},
			MT: &backend.MTClient{
				BaseURL: env("MT_URL", "http://localhost:8080"), APIKey: os.Getenv("MT_API_KEY"),
				Model: env("MT_MODEL", "bench-qwen36"), HTTP: httpc,
			},
			TTS:           tts,
			Limits:        session.NewLimits(asrSlots, mtSlots, ttsSlots),
			DefaultVoices: defaultVoices,
			ASRTimeout:    15 * time.Second, MTTimeout: 20 * time.Second, TTSTimeout: 20 * time.Second,
			Logger: logger,
		},
	}
	mux := http.NewServeMux()
	mux.Handle("GET /v1/ws", h)
	if voiceURL != "" {
		library, err := voiceLibrary(voiceURL, h)
		if err != nil {
			return err
		}
		mux.Handle("/v1/voices", library)
		mux.Handle("/v1/voices/", library)
	}
	mux.Handle("GET /healthz", &health.Checker{
		HTTP: httpc, Sessions: h.Active, Probes: healthProbes(ttsURL, voiceURL),
	})

	srv := &http.Server{Addr: env("TRANSLATOR_ADDR", ":8096"), Handler: mux, ReadHeaderTimeout: 10 * time.Second}
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()
	errc := make(chan error, 1)
	go func() { errc <- srv.ListenAndServe() }()
	logger.Info("listening", "addr", srv.Addr, "model", strings.TrimSpace(env("MT_MODEL", "bench-qwen36")))
	select {
	case err := <-errc:
		return fmt.Errorf("serve: %w", err)
	case <-ctx.Done():
	}
	sctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	return srv.Shutdown(sctx)
}
