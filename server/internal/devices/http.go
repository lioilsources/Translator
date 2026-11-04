package devices

import (
	"encoding/json"
	"io"
	"net/http"
)

const maxBody = 4 << 10

// RegisterHandler serves POST /v1/devices.
func (s *Service) RegisterHandler() http.Handler { return s.handle(s.Register) }

// UpgradeHandler serves POST /v1/devices/upgrade.
func (s *Service) UpgradeHandler() http.Handler { return s.handle(s.Upgrade) }

// MeHandler serves GET /v1/devices/me: who the token belongs to, so the app
// can tell a dead token before it opens a conversation.
func (s *Service) MeHandler() http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		d, ok := s.Authorize(r)
		if !ok {
			http.Error(w, "unauthorized", http.StatusUnauthorized)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{"deviceId": d.ID, "tier": d.Tier})
	})
}

func (s *Service) handle(do func(*http.Request, Request) (Issued, int, error)) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		var req Request
		body, err := io.ReadAll(http.MaxBytesReader(w, r.Body, maxBody))
		if err == nil && len(body) > 0 {
			err = json.Unmarshal(body, &req)
		}
		if err != nil {
			http.Error(w, "invalid body", http.StatusBadRequest)
			return
		}
		issued, status, err := do(r, req)
		if err != nil {
			http.Error(w, err.Error(), status)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Cache-Control", "no-store")
		w.WriteHeader(status)
		_ = json.NewEncoder(w).Encode(issued)
	})
}
