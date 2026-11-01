// Package health reports whether the services a conversation needs answer.
package health

import (
	"context"
	"encoding/json"
	"net/http"
	"sync"
	"time"
)

const (
	probeTimeout = 2 * time.Second
	cacheFor     = 5 * time.Second
)

// Probe is one dependency. Required ones decide readiness.
type Probe struct {
	Name, URL, Bearer string
	Required          bool
}

// Report is the /healthz body.
type Report struct {
	Status   string          `json:"status"` // "ready" or "degraded"
	Services map[string]bool `json:"services"`
	Sessions int32           `json:"sessions"`
}

// Checker probes dependencies, at most once per cacheFor, because the endpoint
// is public and must not let callers hammer the model servers.
type Checker struct {
	Probes   []Probe
	HTTP     *http.Client
	Sessions func() int32

	mu      sync.Mutex
	checked time.Time
	last    Report
}

func (c *Checker) check(ctx context.Context) Report {
	c.mu.Lock()
	defer c.mu.Unlock()
	if !c.checked.IsZero() && time.Since(c.checked) < cacheFor {
		return c.last
	}
	results := make([]bool, len(c.Probes))
	var wg sync.WaitGroup
	for i, p := range c.Probes {
		wg.Add(1)
		go func() {
			defer wg.Done()
			results[i] = c.alive(ctx, p)
		}()
	}
	wg.Wait()
	report := Report{Status: "ready", Services: make(map[string]bool, len(c.Probes))}
	for i, p := range c.Probes {
		report.Services[p.Name] = results[i]
		if p.Required && !results[i] {
			report.Status = "degraded"
		}
	}
	c.checked, c.last = time.Now(), report
	return report
}

func (c *Checker) alive(ctx context.Context, p Probe) bool {
	ctx, cancel := context.WithTimeout(ctx, probeTimeout)
	defer cancel()
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, p.URL, nil)
	if err != nil {
		return false
	}
	if p.Bearer != "" {
		req.Header.Set("Authorization", "Bearer "+p.Bearer)
	}
	resp, err := c.HTTP.Do(req)
	if err != nil {
		return false
	}
	defer resp.Body.Close()
	return resp.StatusCode < 300
}

// ServeHTTP implements http.Handler. It answers 200 with the status in the
// body, so a degraded server stays distinguishable from an unreachable one.
func (c *Checker) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	report := c.check(r.Context())
	report.Sessions = c.Sessions()
	w.Header().Set("Content-Type", "application/json")
	_ = json.NewEncoder(w).Encode(report)
}
