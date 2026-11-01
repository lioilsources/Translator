package health

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"sync/atomic"
	"testing"
)

func serve(status int, hits *atomic.Int32) *httptest.Server {
	return httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, _ *http.Request) {
		if hits != nil {
			hits.Add(1)
		}
		w.WriteHeader(status)
	}))
}

func get(t *testing.T, c *Checker) Report {
	t.Helper()
	rec := httptest.NewRecorder()
	c.ServeHTTP(rec, httptest.NewRequest(http.MethodGet, "/healthz", nil))
	var r Report
	if err := json.Unmarshal(rec.Body.Bytes(), &r); err != nil {
		t.Fatal(err)
	}
	return r
}

func TestRequiredFailureDegrades(t *testing.T) {
	up, down := serve(200, nil), serve(503, nil)
	defer up.Close()
	defer down.Close()
	c := &Checker{HTTP: http.DefaultClient, Sessions: func() int32 { return 1 }, Probes: []Probe{
		{Name: "asr", URL: up.URL, Required: true},
		{Name: "mt", URL: down.URL, Required: true},
	}}
	r := get(t, c)
	if r.Status != "degraded" || !r.Services["asr"] || r.Services["mt"] || r.Sessions != 1 {
		t.Fatalf("%+v", r)
	}
}

func TestOptionalFailureStaysReady(t *testing.T) {
	up, down := serve(200, nil), serve(503, nil)
	defer up.Close()
	defer down.Close()
	c := &Checker{HTTP: http.DefaultClient, Sessions: func() int32 { return 0 }, Probes: []Probe{
		{Name: "asr", URL: up.URL, Required: true},
		{Name: "voice", URL: down.URL},
	}}
	if r := get(t, c); r.Status != "ready" || r.Services["voice"] {
		t.Fatalf("%+v", r)
	}
}

func TestProbesAreCached(t *testing.T) {
	var hits atomic.Int32
	up := serve(200, &hits)
	defer up.Close()
	c := &Checker{HTTP: http.DefaultClient, Sessions: func() int32 { return 0 },
		Probes: []Probe{{Name: "asr", URL: up.URL, Required: true}}}
	get(t, c)
	get(t, c)
	if hits.Load() != 1 {
		t.Fatalf("hits %d", hits.Load())
	}
}
