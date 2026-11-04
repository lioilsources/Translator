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
	"translator/server/internal/devices"
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
func voiceLibrary(target string, auth *devices.Service) (http.Handler, error) {
	u, err := url.Parse(target)
	if err != nil {
		return nil, fmt.Errorf("VOICE_URL: %w", err)
	}
	proxy := httputil.NewSingleHostReverseProxy(u)
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		dev, ok := auth.Authorize(r)
		if !ok {
			http.Error(w, "unauthorized", http.StatusUnauthorized)
			return
		}
		if dev.ID != "" {
			// The library is the token's device, whatever the client asks for.
			q := r.URL.Query()
			q.Set("device", dev.ID)
			r.URL.RawQuery = q.Encode()
		}
		// Cloning is XTTS-v2, non-commercial: testers only.
		if dev.Tier == devices.Public && r.Method == http.MethodPost {
			http.Error(w, "recording a voice needs an invite code", http.StatusForbidden)
			return
		}
		r.Body = http.MaxBytesReader(w, r.Body, maxRecording)
		proxy.ServeHTTP(w, r)
	}), nil
}

// deviceService reads the device token settings. Without DEVICE_KEY only the
// shared token works, as before.
func deviceService(token string) (*devices.Service, error) {
	svc := &devices.Service{Shared: token, Invite: os.Getenv("INVITE_CODE")}
	if key := os.Getenv("DEVICE_KEY"); key != "" {
		issuer, err := devices.NewIssuer(key)
		if err != nil {
			return nil, err
		}
		svc.Issuer = issuer
	}
	svc.Deny = devices.ParseDenylist(os.Getenv("DEVICE_DENY"))
	for _, v := range []struct {
		key      string
		fallback int
		into     *int
	}{
		{"PUBLIC_MINUTES", 20, &svc.Limits.PublicMinutes},
		{"TESTER_MINUTES", 300, &svc.Limits.TesterMinutes},
		{"REGISTER_PER_IP", 5, &svc.PerIP},
		{"REGISTER_PER_DAY", 200, &svc.PerDay},
	} {
		n, err := envInt(v.key, v.fallback)
		if err != nil {
			return nil, err
		}
		*v.into = n
	}
	return svc, nil
}

func run(logger *slog.Logger) error {
	token := os.Getenv("TRANSLATOR_TOKEN")
	if token == "" && os.Getenv("DEVICE_KEY") == "" && os.Getenv("TRANSLATOR_ALLOW_ANON") != "1" {
		return errors.New("set DEVICE_KEY and/or TRANSLATOR_TOKEN, or TRANSLATOR_ALLOW_ANON=1 for local development")
	}
	auth, err := deviceService(token)
	if err != nil {
		return err
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
		Devices: auth, MaxSessions: int32(maxSessions), IdleTimeout: 30 * time.Minute, Logger: logger,
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
		library, err := voiceLibrary(voiceURL, auth)
		if err != nil {
			return err
		}
		mux.Handle("/v1/voices", library)
		mux.Handle("/v1/voices/", library)
	}
	if auth.Issuer != nil {
		mux.Handle("POST /v1/devices", auth.RegisterHandler())
		mux.Handle("POST /v1/devices/upgrade", auth.UpgradeHandler())
		mux.Handle("GET /v1/devices/me", auth.MeHandler())
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
