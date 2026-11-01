// Package ws exposes the conversation protocol over WebSocket.
package ws

import (
	"context"
	"crypto/subtle"
	"encoding/json"
	"errors"
	"log/slog"
	"net/http"
	"regexp"
	"strings"
	"sync/atomic"
	"time"

	"github.com/coder/websocket"

	"translator/server/internal/protocol"
	"translator/server/internal/session"
)

const (
	maxFrame     = 1 << 20
	writeTimeout = 15 * time.Second
	pingEvery    = 20 * time.Second
)

var langRe = regexp.MustCompile(`^[a-z]{2,3}$`)

// Handler upgrades connections and runs one session per connection.
type Handler struct {
	Deps        session.Deps
	Token       string // empty disables auth
	MaxSessions int32
	IdleTimeout time.Duration
	Logger      *slog.Logger
	active      atomic.Int32
}

// Active returns the number of open connections.
func (h *Handler) Active() int32 { return h.active.Load() }

// Authorized reports whether the request carries the shared token.
func (h *Handler) Authorized(r *http.Request) bool {
	if h.Token == "" {
		return true
	}
	got, ok := strings.CutPrefix(r.Header.Get("Authorization"), "Bearer ")
	return ok && subtle.ConstantTimeCompare([]byte(got), []byte(h.Token)) == 1
}

// ServeHTTP implements http.Handler.
func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if !h.Authorized(r) {
		http.Error(w, "unauthorized", http.StatusUnauthorized)
		return
	}
	conn, err := websocket.Accept(w, r, &websocket.AcceptOptions{OriginPatterns: nil})
	if err != nil {
		h.Logger.Warn("accept failed", "err", err)
		return
	}
	defer conn.CloseNow()
	conn.SetReadLimit(maxFrame)

	if h.active.Add(1) > h.MaxSessions {
		h.active.Add(-1)
		e := &emitter{ctx: r.Context(), conn: conn}
		_ = e.JSON(protocol.Error{Type: protocol.TypeError, Code: protocol.ErrBusy, Message: "server is at capacity"})
		conn.Close(websocket.StatusTryAgainLater, "busy")
		return
	}
	defer h.active.Add(-1)

	ctx, cancel := context.WithCancel(r.Context())
	defer cancel()
	go ping(ctx, conn)
	h.readLoop(ctx, conn)
}

func ping(ctx context.Context, conn *websocket.Conn) {
	t := time.NewTicker(pingEvery)
	defer t.Stop()
	for {
		select {
		case <-ctx.Done():
			return
		case <-t.C:
			pctx, cancel := context.WithTimeout(ctx, writeTimeout)
			err := conn.Ping(pctx)
			cancel()
			if err != nil {
				return
			}
		}
	}
}

func (h *Handler) readLoop(ctx context.Context, conn *websocket.Conn) {
	out := &emitter{ctx: ctx, conn: conn}
	var s *session.Session
	defer func() {
		if s != nil {
			s.Close()
		}
	}()
	for {
		rctx, cancel := context.WithTimeout(ctx, h.IdleTimeout)
		kind, data, err := conn.Read(rctx)
		cancel()
		if err != nil {
			if !errors.Is(err, context.Canceled) && websocket.CloseStatus(err) == -1 {
				h.Logger.Info("connection ended", "err", err)
			}
			return
		}
		if kind == websocket.MessageBinary {
			if s == nil {
				sendError(out, protocol.ErrNoSession, "send session.start first")
				continue
			}
			s.HandleAudio(data)
			continue
		}
		var env protocol.Envelope
		if err := json.Unmarshal(data, &env); err != nil {
			sendError(out, protocol.ErrBadRequest, "invalid json")
			continue
		}
		if env.Type == protocol.TypeSessionStart {
			if s != nil {
				sendError(out, protocol.ErrBadRequest, "session already started")
				continue
			}
			s = h.start(ctx, out, data)
			continue
		}
		if s == nil {
			sendError(out, protocol.ErrNoSession, "send session.start first")
			continue
		}
		switch env.Type {
		case protocol.TypeAudioEnd:
			var m protocol.AudioEnd
			if err := json.Unmarshal(data, &m); err != nil || (m.Side != "" && !m.Side.Valid()) {
				sendError(out, protocol.ErrBadRequest, "invalid audio.end")
				continue
			}
			s.HandleAudioEnd(m.Side)
		case protocol.TypeAudioCancel:
			s.HandleAudioCancel()
		case protocol.TypeSpeakerForce:
			var m protocol.SpeakerForce
			if err := json.Unmarshal(data, &m); err != nil || !m.Side.Valid() {
				sendError(out, protocol.ErrBadRequest, "invalid speaker.force")
				continue
			}
			s.HandleForce(m.Side)
		case protocol.TypeSessionConfig:
			var m protocol.SessionConfig
			if err := json.Unmarshal(data, &m); err != nil {
				sendError(out, protocol.ErrBadRequest, "invalid session.config")
				continue
			}
			s.HandleConfig(m)
		case protocol.TypeSessionEnd:
			s.Close()
			s = nil
			conn.Close(websocket.StatusNormalClosure, "")
			return
		default:
			sendError(out, protocol.ErrBadRequest, "unknown type")
		}
	}
}

func (h *Handler) start(ctx context.Context, out *emitter, data []byte) *session.Session {
	var m protocol.SessionStart
	if err := json.Unmarshal(data, &m); err != nil || !langRe.MatchString(m.LangA) || !langRe.MatchString(m.LangB) {
		sendError(out, protocol.ErrBadRequest, "invalid session.start")
		return nil
	}
	switch m.Mode {
	case protocol.ModeAuto, protocol.ModePTT, protocol.ModeStreaming:
	case "":
		m.Mode = protocol.ModeAuto
	default:
		sendError(out, protocol.ErrBadRequest, "invalid mode")
		return nil
	}
	s := session.New(ctx, h.Deps, out, m)
	_ = out.JSON(protocol.SessionReady{
		Type: protocol.TypeSessionReady, SessionID: newID(), Protocol: protocol.Version,
	})
	h.Logger.Info("session started", "langA", m.LangA, "langB", m.LangB, "mode", m.Mode)
	return s
}

func sendError(out *emitter, code, msg string) {
	_ = out.JSON(protocol.Error{Type: protocol.TypeError, Code: code, Message: msg})
}

type emitter struct {
	ctx  context.Context
	conn *websocket.Conn
}

func (e *emitter) JSON(v any) error {
	b, err := json.Marshal(v)
	if err != nil {
		return err
	}
	return e.write(websocket.MessageText, b)
}

func (e *emitter) Binary(b []byte) error { return e.write(websocket.MessageBinary, b) }

func (e *emitter) write(kind websocket.MessageType, b []byte) error {
	ctx, cancel := context.WithTimeout(e.ctx, writeTimeout)
	defer cancel()
	return e.conn.Write(ctx, kind, b)
}
