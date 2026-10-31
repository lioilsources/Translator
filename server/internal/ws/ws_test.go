package ws

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"net/http/httptest"
	"strings"
	"sync"
	"testing"
	"time"

	"github.com/coder/websocket"

	"translator/server/internal/backend"
	"translator/server/internal/protocol"
	"translator/server/internal/session"
)

type fakeASR struct {
	mu   sync.Mutex
	next []backend.ASRResult
	last backend.ASRRequest
	err  error
}

func (f *fakeASR) Transcribe(_ context.Context, r backend.ASRRequest) (backend.ASRResult, error) {
	f.mu.Lock()
	defer f.mu.Unlock()
	f.last = r
	if f.err != nil {
		return backend.ASRResult{}, f.err
	}
	if len(f.next) == 0 {
		return backend.ASRResult{Text: "Ahoj", Probs: map[string]float64{"cs": .95, "en": .02}}, nil
	}
	r0 := f.next[0]
	if len(f.next) > 1 {
		f.next = f.next[1:]
	}
	return r0, nil
}

type fakeMT struct {
	deltas []string
	err    error
}

func (f *fakeMT) Translate(_ context.Context, _ backend.MTRequest, on func(string)) error {
	for _, d := range f.deltas {
		on(d)
	}
	return f.err
}

type fakeTTS struct {
	err error
}

func (f *fakeTTS) Format() string { return "mp3" }
func (f *fakeTTS) Synthesize(_ context.Context, r backend.TTSRequest) ([]byte, error) {
	if f.err != nil {
		return nil, f.err
	}
	return []byte("audio:" + r.Language + ":" + r.Voice), nil
}

type rig struct {
	asr *fakeASR
	mt  *fakeMT
	tts *fakeTTS
	url string
	h   *Handler
}

func newRig(t *testing.T, token string) *rig {
	t.Helper()
	r := &rig{asr: &fakeASR{}, mt: &fakeMT{deltas: []string{"Hello there, my friend. ", "How are you today?"}}, tts: &fakeTTS{}}
	log := slog.New(slog.NewTextHandler(io.Discard, nil))
	r.h = &Handler{
		Token: token, MaxSessions: 8, IdleTimeout: time.Minute, Logger: log,
		Deps: session.Deps{
			ASR: r.asr, MT: r.mt, TTS: r.tts, Limits: session.NewLimits(2, 5, 3),
			DefaultVoices: map[string]string{"en": "kokoro:x", "cs": "piper:y"},
			ASRTimeout:    5 * time.Second, MTTimeout: 5 * time.Second, TTSTimeout: 5 * time.Second,
			Logger: log,
		},
	}
	srv := httptest.NewServer(r.h)
	t.Cleanup(srv.Close)
	r.url = "ws" + strings.TrimPrefix(srv.URL, "http")
	return r
}

type client struct {
	t    *testing.T
	conn *websocket.Conn
	ctx  context.Context
}

func dial(t *testing.T, r *rig, start string) *client {
	t.Helper()
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	t.Cleanup(cancel)
	conn, _, err := websocket.Dial(ctx, r.url, nil)
	if err != nil {
		t.Fatal(err)
	}
	t.Cleanup(func() { conn.CloseNow() })
	c := &client{t: t, conn: conn, ctx: ctx}
	c.text(start)
	if m := c.read(); m.typ != protocol.TypeSessionReady {
		t.Fatalf("want ready, got %+v", m)
	}
	return c
}

func (c *client) text(s string) {
	c.t.Helper()
	if err := c.conn.Write(c.ctx, websocket.MessageText, []byte(s)); err != nil {
		c.t.Fatal(err)
	}
}

func (c *client) audio(seconds float64) {
	c.t.Helper()
	if err := c.conn.Write(c.ctx, websocket.MessageBinary, make([]byte, int(seconds*32000))); err != nil {
		c.t.Fatal(err)
	}
}

type frame struct {
	typ    string
	raw    map[string]any
	binary []byte
}

func (c *client) read() frame {
	c.t.Helper()
	kind, data, err := c.conn.Read(c.ctx)
	if err != nil {
		c.t.Fatal(err)
	}
	if kind == websocket.MessageBinary {
		return frame{typ: "binary", binary: data}
	}
	var m map[string]any
	if err := json.Unmarshal(data, &m); err != nil {
		c.t.Fatal(err)
	}
	return frame{typ: m["type"].(string), raw: m}
}

// untilEnd collects frames through utterance.end.
func (c *client) untilEnd() []frame {
	c.t.Helper()
	var out []frame
	for {
		f := c.read()
		out = append(out, f)
		if f.typ == protocol.TypeUtteranceEnd {
			return out
		}
	}
}

func find(fs []frame, typ string) *frame {
	for i := range fs {
		if fs[i].typ == typ {
			return &fs[i]
		}
	}
	return nil
}

func indexOf(fs []frame, typ string) int {
	for i := range fs {
		if fs[i].typ == typ {
			return i
		}
	}
	return -1
}

const start = `{"type":"session.start","langA":"cs","langB":"en","mode":"auto"}`

func TestFullUtteranceOrder(t *testing.T) {
	r := newRig(t, "")
	c := dial(t, r, start)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()

	final := find(fs, protocol.TypeASRFinal)
	if final == nil || final.raw["side"] != "a" || final.raw["lang"] != "cs" || final.raw["uncertain"] != false {
		t.Fatalf("asr.final: %+v", final)
	}
	mt := find(fs, protocol.TypeMTFinal)
	if mt == nil || mt.raw["text"] != "Hello there, my friend. How are you today?" || mt.raw["lang"] != "en" {
		t.Fatalf("mt.final: %+v", mt)
	}
	if indexOf(fs, protocol.TypeASRFinal) > indexOf(fs, protocol.TypeMTFinal) {
		t.Fatal("asr.final must precede mt.final")
	}
	clips := 0
	for _, f := range fs {
		if f.typ == "binary" {
			clips++
			if string(f.binary) != "audio:en:kokoro:x" {
				t.Fatalf("clip routed wrong: %s", f.binary)
			}
		}
	}
	if clips != 2 {
		t.Fatalf("want one clip per sentence, got %d", clips)
	}
	if fs[len(fs)-1].raw["status"] != protocol.StatusOK {
		t.Fatalf("end: %+v", fs[len(fs)-1])
	}
}

func TestShortUtteranceDropped(t *testing.T) {
	c := dial(t, newRig(t, ""), start)
	c.audio(.3)
	c.text(`{"type":"audio.end"}`)
	f := c.read()
	if f.raw["status"] != protocol.StatusDropped || f.raw["reason"] != "too_short" {
		t.Fatalf("%+v", f)
	}
}

func TestHallucinationDropped(t *testing.T) {
	r := newRig(t, "")
	r.asr.next = []backend.ASRResult{{Text: "Thanks for watching!", Probs: map[string]float64{"en": .9}}}
	c := dial(t, r, start)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	if find(fs, protocol.TypeASRFinal) != nil || fs[0].raw["reason"] != "no_speech" {
		t.Fatalf("%+v", fs)
	}
}

func TestUncertainThenForcedTranslates(t *testing.T) {
	r := newRig(t, "")
	r.asr.next = []backend.ASRResult{{Text: "Hmm tak", Probs: map[string]float64{"cs": .4, "en": .35}}}
	c := dial(t, r, start)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	if f := find(fs, protocol.TypeASRFinal); f.raw["uncertain"] != true {
		t.Fatalf("%+v", f)
	}
	if find(fs, protocol.TypeMTFinal) != nil || find(fs, "binary") != nil {
		t.Fatal("uncertain utterance must not translate or speak")
	}
	c.text(`{"type":"speaker.force","side":"b"}`)
	fs = c.untilEnd()
	if f := find(fs, protocol.TypeASRFinal); f.raw["side"] != "b" || f.raw["lang"] != "en" {
		t.Fatalf("%+v", f)
	}
	if f := find(fs, protocol.TypeMTFinal); f.raw["lang"] != "cs" {
		t.Fatalf("%+v", f)
	}
}

func TestPushToTalkForcesLanguage(t *testing.T) {
	r := newRig(t, "")
	c := dial(t, r, start)
	c.audio(1)
	c.text(`{"type":"audio.end","side":"b"}`)
	c.untilEnd()
	r.asr.mu.Lock()
	defer r.asr.mu.Unlock()
	if r.asr.last.Language != "en" {
		t.Fatalf("%+v", r.asr.last)
	}
}

func TestStickyForceAppliesToNextOnly(t *testing.T) {
	r := newRig(t, "")
	c := dial(t, r, start)
	c.text(`{"type":"speaker.force","side":"b"}`)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	if f := find(c.untilEnd(), protocol.TypeASRFinal); f.raw["side"] != "b" {
		t.Fatalf("%+v", f)
	}
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	if f := find(c.untilEnd(), protocol.TypeASRFinal); f.raw["side"] != "a" {
		t.Fatalf("%+v", f)
	}
}

func TestTTSDisabled(t *testing.T) {
	c := dial(t, newRig(t, ""), `{"type":"session.start","langA":"cs","langB":"en","tts":false}`)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	if find(fs, protocol.TypeMTFinal) == nil || find(fs, "binary") != nil {
		t.Fatalf("%+v", fs)
	}
}

func TestTTSFailureKeepsText(t *testing.T) {
	r := newRig(t, "")
	r.tts.err = errors.New("503")
	c := dial(t, r, start)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	if find(fs, protocol.TypeMTFinal) == nil {
		t.Fatal("translation must survive TTS failure")
	}
	if e := find(fs, protocol.TypeError); e == nil || e.raw["code"] != protocol.ErrTTSUnavailable {
		t.Fatalf("%+v", fs)
	}
	if fs[len(fs)-1].raw["status"] != protocol.StatusFailed {
		t.Fatalf("%+v", fs[len(fs)-1])
	}
}

func TestMTFailureMidStreamDoesNotHang(t *testing.T) {
	r := newRig(t, "")
	r.mt.err = errors.New("boom")
	c := dial(t, r, start)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	if e := find(fs, protocol.TypeError); e == nil || e.raw["code"] != protocol.ErrMTUnavailable {
		t.Fatalf("%+v", fs)
	}
}

func TestASRFailure(t *testing.T) {
	r := newRig(t, "")
	r.asr.err = errors.New("down")
	c := dial(t, r, start)
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	if e := find(fs, protocol.TypeError); e == nil || e.raw["code"] != protocol.ErrASRUnavailable {
		t.Fatalf("%+v", fs)
	}
}

func TestSameLanguageUsesVoiceAfterEnrollment(t *testing.T) {
	r := newRig(t, "")
	a, b := []float64{1, 0}, []float64{0, 1}
	probs := map[string]float64{"cs": .99}
	r.asr.next = []backend.ASRResult{
		{Text: "jedna", Probs: probs, Embedding: a},
		{Text: "dva", Probs: probs, Embedding: a},
		{Text: "tri", Probs: probs, Embedding: b},
		{Text: "ctyri", Probs: probs, Embedding: b},
		{Text: "pet", Probs: probs, Embedding: b},
	}
	c := dial(t, r, `{"type":"session.start","langA":"cs","langB":"cs"}`)
	for _, side := range []string{"a", "a", "b", "b"} {
		c.audio(1)
		c.text(fmt.Sprintf(`{"type":"audio.end","side":%q}`, side))
		c.untilEnd()
	}
	c.audio(1)
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	if f := find(fs, protocol.TypeASRFinal); f.raw["side"] != "b" || f.raw["uncertain"] != false {
		t.Fatalf("%+v", f)
	}
	if f := find(fs, protocol.TypeMTFinal); f.raw["text"] != "pet" {
		t.Fatalf("same language must pass through, got %+v", f)
	}
}

func TestStreamingEmitsPartial(t *testing.T) {
	c := dial(t, newRig(t, ""), `{"type":"session.start","langA":"cs","langB":"en","mode":"streaming"}`)
	c.audio(2)
	if f := c.read(); f.typ != protocol.TypeASRPartial || f.raw["text"] != "Ahoj" {
		t.Fatalf("%+v", f)
	}
	c.text(`{"type":"audio.end"}`)
	fs := c.untilEnd()
	for _, f := range fs[indexOf(fs, protocol.TypeASRFinal):] {
		if f.typ == protocol.TypeASRPartial {
			t.Fatal("partial after final")
		}
	}
}

func TestAudioBeforeStartRejected(t *testing.T) {
	r := newRig(t, "")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	conn, _, err := websocket.Dial(ctx, r.url, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer conn.CloseNow()
	if err := conn.Write(ctx, websocket.MessageBinary, []byte{0, 0}); err != nil {
		t.Fatal(err)
	}
	_, data, err := conn.Read(ctx)
	if err != nil || !strings.Contains(string(data), protocol.ErrNoSession) {
		t.Fatalf("%s %v", data, err)
	}
}

func TestInvalidLanguageRejected(t *testing.T) {
	r := newRig(t, "")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	conn, _, err := websocket.Dial(ctx, r.url, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer conn.CloseNow()
	_ = conn.Write(ctx, websocket.MessageText, []byte(`{"type":"session.start","langA":"cs&x=1","langB":"en"}`))
	_, data, err := conn.Read(ctx)
	if err != nil || !strings.Contains(string(data), protocol.ErrBadRequest) {
		t.Fatalf("%s %v", data, err)
	}
}

func TestAuth(t *testing.T) {
	r := newRig(t, "secret")
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if _, resp, err := websocket.Dial(ctx, r.url, nil); err == nil || resp.StatusCode != http.StatusUnauthorized {
		t.Fatalf("want 401, got %v", err)
	}
	conn, _, err := websocket.Dial(ctx, r.url, &websocket.DialOptions{
		HTTPHeader: http.Header{"Authorization": {"Bearer secret"}},
	})
	if err != nil {
		t.Fatal(err)
	}
	conn.CloseNow()
}

func TestCapacity(t *testing.T) {
	r := newRig(t, "")
	r.h.MaxSessions = 1
	dial(t, r, start)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	conn, _, err := websocket.Dial(ctx, r.url, nil)
	if err != nil {
		t.Fatal(err)
	}
	defer conn.CloseNow()
	_, data, err := conn.Read(ctx)
	if err != nil || !strings.Contains(string(data), protocol.ErrBusy) {
		t.Fatalf("%s %v", data, err)
	}
}

func TestFiveConcurrentSessions(t *testing.T) {
	r := newRig(t, "")
	var wg sync.WaitGroup
	for range 5 {
		c := dial(t, r, start)
		wg.Add(1)
		go func() {
			defer wg.Done()
			for range 5 {
				if err := c.conn.Write(c.ctx, websocket.MessageBinary, make([]byte, 32000)); err != nil {
					t.Error(err)
					return
				}
				if err := c.conn.Write(c.ctx, websocket.MessageText, []byte(`{"type":"audio.end"}`)); err != nil {
					t.Error(err)
					return
				}
				for {
					_, data, err := c.conn.Read(c.ctx)
					if err != nil {
						t.Error(err)
						return
					}
					if strings.Contains(string(data), protocol.TypeUtteranceEnd) {
						if !strings.Contains(string(data), protocol.StatusOK) {
							t.Errorf("%s", data)
						}
						break
					}
				}
			}
		}()
	}
	wg.Wait()
}
