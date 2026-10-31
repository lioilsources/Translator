// Package session runs one conversation: it buffers audio into utterances and
// drives each through ASR, MT and TTS, one utterance at a time.
package session

import (
	"context"
	"errors"
	"log/slog"
	"strings"
	"sync"
	"time"

	"translator/server/internal/backend"
	"translator/server/internal/protocol"
	"translator/server/internal/speaker"
)

const (
	bytesPerSecond = 32000 // 16 kHz, mono, PCM16
	minUtterance   = bytesPerSecond / 2
	maxUtterance   = 30 * bytesPerSecond
	partialEvery   = 3 * bytesPerSecond / 2
	historyTurns   = 3
	queueSize      = 8
)

// Emitter delivers frames to the client.
type Emitter interface {
	JSON(v any) error
	Binary(b []byte) error
}

// Limits caps concurrent calls across all sessions, so a burst queues on the
// server instead of overloading SPARK.
type Limits struct {
	ASR, MT, TTS chan struct{}
}

// NewLimits creates limits with the given concurrency.
func NewLimits(asr, mt, tts int) *Limits {
	return &Limits{ASR: make(chan struct{}, asr), MT: make(chan struct{}, mt), TTS: make(chan struct{}, tts)}
}

func acquire(ctx context.Context, sem chan struct{}) error {
	select {
	case sem <- struct{}{}:
		return nil
	case <-ctx.Done():
		return ctx.Err()
	}
}

// Deps are the collaborators shared by all sessions.
type Deps struct {
	ASR           backend.ASR
	MT            backend.MT
	TTS           backend.TTS
	Limits        *Limits
	DefaultVoices map[string]string
	ASRTimeout    time.Duration
	MTTimeout     time.Duration
	TTSTimeout    time.Duration
	Logger        *slog.Logger
}

type utterance struct {
	id     int
	pcm    []byte
	forced protocol.Side
	// resolvedText is set for an uncertain utterance the user has assigned;
	// it needs no second ASR pass.
	resolvedText string
}

type pendingUncertain struct {
	id   int
	text string
}

// Session belongs to one connection. Handle* calls come from its read loop.
type Session struct {
	deps Deps
	out  Emitter
	cfg  protocol.SessionStart

	ctx     context.Context
	cancel  context.CancelFunc
	queue   chan utterance
	workers sync.WaitGroup

	// Read loop only.
	buf         []byte
	lastPartial int
	nextID      int
	overflowed  bool
	partialStop context.CancelFunc
	partialDone chan struct{}

	// Shared with the worker goroutine.
	mu      sync.Mutex
	tts     bool
	forced  protocol.Side
	pending *pendingUncertain
	history []backend.Turn
	tracker *speaker.Tracker
}

// New validates the start message and launches the session worker.
func New(parent context.Context, deps Deps, out Emitter, cfg protocol.SessionStart) *Session {
	ctx, cancel := context.WithCancel(parent)
	s := &Session{
		deps: deps, out: out, cfg: cfg, ctx: ctx, cancel: cancel,
		queue: make(chan utterance, queueSize), tts: cfg.TTS == nil || *cfg.TTS,
		tracker: speaker.NewTracker(),
	}
	s.workers.Add(1)
	go s.run()
	return s
}

// Close stops the worker and cancels in-flight calls.
func (s *Session) Close() {
	s.stopPartial()
	s.cancel()
	s.workers.Wait()
}

// HandleAudio buffers one binary PCM frame.
func (s *Session) HandleAudio(pcm []byte) {
	if s.overflowed {
		return
	}
	if len(s.buf)+len(pcm) > maxUtterance {
		s.overflowed = true
		s.emitError(protocol.ErrTooLong, "utterance exceeds 30 seconds", 0)
		return
	}
	s.buf = append(s.buf, pcm...)
	if s.cfg.Mode == protocol.ModeStreaming && len(s.buf)-s.lastPartial >= partialEvery {
		s.startPartial()
	}
}

// HandleAudioCancel drops buffered audio without processing it.
func (s *Session) HandleAudioCancel() {
	s.stopPartial()
	s.resetBuffer()
}

// HandleAudioEnd queues the buffered audio as an utterance.
func (s *Session) HandleAudioEnd(side protocol.Side) {
	s.stopPartial()
	pcm := s.buf
	overflowed := s.overflowed
	s.resetBuffer()
	if overflowed {
		return
	}
	s.nextID++
	id := s.nextID
	if len(pcm) < minUtterance {
		s.emitEnd(id, protocol.StatusDropped, "too_short")
		return
	}
	s.mu.Lock()
	forced := side
	if forced == "" {
		forced = s.forced
	}
	s.forced = ""
	s.mu.Unlock()
	select {
	case s.queue <- utterance{id: id, pcm: pcm, forced: forced}:
	default:
		s.emitError(protocol.ErrQueueFull, "too many utterances waiting", id)
		s.emitEnd(id, protocol.StatusFailed, protocol.ErrQueueFull)
	}
}

// HandleForce resolves the waiting uncertain utterance, or sticks to the next.
func (s *Session) HandleForce(side protocol.Side) {
	s.mu.Lock()
	p := s.pending
	s.pending = nil
	if p == nil {
		s.forced = side
	}
	s.mu.Unlock()
	if p == nil {
		return
	}
	// Through the queue: frames of two utterances must never interleave.
	select {
	case s.queue <- utterance{id: p.id, forced: side, resolvedText: p.text}:
	default:
		s.emitError(protocol.ErrQueueFull, "too many utterances waiting", p.id)
		s.emitEnd(p.id, protocol.StatusFailed, protocol.ErrQueueFull)
	}
}

// HandleConfig applies runtime options.
func (s *Session) HandleConfig(c protocol.SessionConfig) {
	if c.TTS == nil {
		return
	}
	s.mu.Lock()
	s.tts = *c.TTS
	s.mu.Unlock()
}

func (s *Session) resetBuffer() {
	s.buf, s.lastPartial, s.overflowed = nil, 0, false
}

func (s *Session) run() {
	defer s.workers.Done()
	for {
		select {
		case <-s.ctx.Done():
			return
		case u := <-s.queue:
			s.process(u)
		}
	}
}

func (s *Session) process(u utterance) {
	if u.resolvedText != "" {
		lang := s.langOf(u.forced)
		s.emit(protocol.ASRFinal{
			Type: protocol.TypeASRFinal, UtteranceID: u.id, Side: u.forced,
			Lang: lang, Text: u.resolvedText, Confidence: 1,
		})
		s.finish(u.id, s.translateAndSpeak(u.id, u.forced, lang, u.resolvedText))
		return
	}
	res, err := s.transcribe(u)
	if err != nil {
		s.fail(u.id, protocol.ErrASRUnavailable, err)
		return
	}
	text := strings.TrimSpace(res.Text)
	if text == "" || isHallucination(text) {
		s.emitEnd(u.id, protocol.StatusDropped, "no_speech")
		return
	}

	s.mu.Lock()
	var d speaker.Decision
	if u.forced != "" {
		d = speaker.Decision{Side: u.forced, Confidence: 1, Lang: s.langOf(u.forced)}
	} else {
		d = s.tracker.Decide(s.cfg.LangA, s.cfg.LangB, res.Probs, res.Embedding)
	}
	if d.Side != "" {
		s.tracker.Enroll(d.Side, res.Embedding)
	} else {
		s.pending = &pendingUncertain{id: u.id, text: text}
	}
	s.mu.Unlock()

	s.emit(protocol.ASRFinal{
		Type: protocol.TypeASRFinal, UtteranceID: u.id, Side: d.Side, Lang: d.Lang,
		Text: text, Confidence: d.Confidence, Uncertain: d.Uncertain,
	})
	if d.Uncertain {
		s.emitEnd(u.id, protocol.StatusUncertain, "")
		return
	}
	s.finish(u.id, s.translateAndSpeak(u.id, d.Side, d.Lang, text))
}

func (s *Session) transcribe(u utterance) (backend.ASRResult, error) {
	req := backend.ASRRequest{PCM: u.pcm, Candidates: []string{s.cfg.LangA, s.cfg.LangB}}
	if u.forced != "" {
		req.Language = s.langOf(u.forced)
	}
	ctx, cancel := context.WithTimeout(s.ctx, s.deps.ASRTimeout)
	defer cancel()
	if err := acquire(ctx, s.deps.Limits.ASR); err != nil {
		return backend.ASRResult{}, err
	}
	defer func() { <-s.deps.Limits.ASR }()
	return s.deps.ASR.Transcribe(ctx, req)
}

// outcome is the result of translateAndSpeak; a zero code means success.
type outcome struct {
	code string
	err  error
}

func (s *Session) finish(id int, o outcome) {
	if o.err != nil {
		s.fail(id, o.code, o.err)
		return
	}
	s.emitEnd(id, protocol.StatusOK, "")
}

// translateAndSpeak streams MT into TTS sentence by sentence. Text always
// reaches the client first; a TTS failure leaves the translation on screen.
func (s *Session) translateAndSpeak(id int, side protocol.Side, lang, text string) outcome {
	target := s.langOf(side.Other())
	s.mu.Lock()
	speak := s.tts
	history := append([]backend.Turn(nil), s.history...)
	s.mu.Unlock()

	if lang == target {
		// Same language on both sides, or a code-switch into the listener's language.
		s.emit(protocol.MTText{Type: protocol.TypeMTFinal, UtteranceID: id, Side: side, Lang: target, Text: text})
		if speak {
			return s.speak(id, target, side.Other(), []string{text})
		}
		return outcome{}
	}

	sentences := make(chan string, 16)
	spoken := make(chan outcome, 1)
	if speak {
		go func() { spoken <- s.speakStream(id, target, side.Other(), sentences) }()
	} else {
		close(sentences)
		spoken <- outcome{}
	}

	var (
		full strings.Builder
		sb   sentenceBuffer
	)
	ctx, cancel := context.WithTimeout(s.ctx, s.deps.MTTimeout)
	defer cancel()
	err := acquire(ctx, s.deps.Limits.MT)
	if err == nil {
		err = s.deps.MT.Translate(ctx, backend.MTRequest{
			From: lang, To: target, Text: text, History: history,
		}, func(delta string) {
			full.WriteString(delta)
			s.emit(protocol.MTText{Type: protocol.TypeMTPartial, UtteranceID: id, Side: side, Lang: target, Text: full.String()})
			if speak {
				for _, snt := range sb.push(delta) {
					sentences <- snt
				}
			}
		})
		<-s.deps.Limits.MT
	}
	translated := strings.TrimSpace(full.String())
	if err == nil && translated == "" {
		err = errors.New("mt: empty translation")
	}
	if err != nil {
		if speak {
			close(sentences)
			<-spoken
		}
		return outcome{protocol.ErrMTUnavailable, err}
	}

	s.emit(protocol.MTText{Type: protocol.TypeMTFinal, UtteranceID: id, Side: side, Lang: target, Text: translated})
	s.remember(text, translated)
	if speak {
		if rest := sb.flush(); rest != "" {
			sentences <- rest
		}
		close(sentences)
	}
	return <-spoken
}

func (s *Session) speak(id int, lang string, listener protocol.Side, sentences []string) outcome {
	ch := make(chan string, len(sentences))
	for _, snt := range sentences {
		ch <- snt
	}
	close(ch)
	return s.speakStream(id, lang, listener, ch)
}

func (s *Session) speakStream(id int, lang string, listener protocol.Side, sentences <-chan string) outcome {
	seq, failed := 0, outcome{}
	for snt := range sentences {
		if failed.err != nil {
			continue // keep draining so the MT callback never blocks
		}
		audio, err := s.synthesize(snt, lang, s.voiceFor(listener, lang))
		if err != nil {
			failed = outcome{protocol.ErrTTSUnavailable, err}
			continue
		}
		s.emit(protocol.TTSStart{Type: protocol.TypeTTSStart, UtteranceID: id, Seq: seq, Format: s.deps.TTS.Format()})
		if err := s.out.Binary(audio); err != nil {
			failed = outcome{protocol.ErrTTSUnavailable, err}
			continue
		}
		seq++
	}
	s.emit(protocol.TTSEnd{Type: protocol.TypeTTSEnd, UtteranceID: id})
	return failed
}

func (s *Session) synthesize(text, lang, voice string) ([]byte, error) {
	ctx, cancel := context.WithTimeout(s.ctx, s.deps.TTSTimeout)
	defer cancel()
	if err := acquire(ctx, s.deps.Limits.TTS); err != nil {
		return nil, err
	}
	defer func() { <-s.deps.Limits.TTS }()
	return s.deps.TTS.Synthesize(ctx, backend.TTSRequest{Text: text, Language: lang, Voice: voice})
}

// voiceFor picks the voice the listener hears: the speaker's chosen voice in
// the listener's language, otherwise the default for that language.
func (s *Session) voiceFor(listener protocol.Side, lang string) string {
	v := s.cfg.VoiceA
	if listener == protocol.SideA {
		v = s.cfg.VoiceB
	}
	if v != "" {
		return v
	}
	return s.deps.DefaultVoices[lang]
}

func (s *Session) remember(source, target string) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.history = append(s.history, backend.Turn{Source: source, Target: target})
	if len(s.history) > historyTurns {
		s.history = s.history[len(s.history)-historyTurns:]
	}
}

func (s *Session) langOf(side protocol.Side) string {
	if side == protocol.SideA {
		return s.cfg.LangA
	}
	return s.cfg.LangB
}

// startPartial transcribes the audio so far. At most one pass runs at a time;
// partials are best effort and skipped while the worker is saturated.
func (s *Session) startPartial() {
	if s.partialDone != nil {
		select {
		case <-s.partialDone:
			s.partialDone = nil
		default:
			return
		}
	}
	select {
	case s.deps.Limits.ASR <- struct{}{}:
	default:
		return
	}
	s.lastPartial = len(s.buf)
	s.mu.Lock()
	forced := s.forced
	s.mu.Unlock()
	req := backend.ASRRequest{PCM: append([]byte(nil), s.buf...), Partial: true, Candidates: []string{s.cfg.LangA, s.cfg.LangB}}
	if forced != "" {
		req.Language = s.langOf(forced)
	}
	ctx, cancel := context.WithTimeout(s.ctx, s.deps.ASRTimeout)
	done := make(chan struct{})
	s.partialStop, s.partialDone = cancel, done
	go func() {
		defer close(done)
		defer cancel()
		defer func() { <-s.deps.Limits.ASR }()
		res, err := s.deps.ASR.Transcribe(ctx, req)
		text := strings.TrimSpace(res.Text)
		if err != nil || text == "" || ctx.Err() != nil {
			return
		}
		side := forced
		if side == "" {
			s.mu.Lock()
			side = s.tracker.Decide(s.cfg.LangA, s.cfg.LangB, res.Probs, nil).Side
			s.mu.Unlock()
		}
		s.emit(protocol.ASRPartial{Type: protocol.TypeASRPartial, Side: side, Text: text})
	}()
}

// stopPartial guarantees no asr.partial arrives after the caller continues.
func (s *Session) stopPartial() {
	if s.partialDone == nil {
		return
	}
	s.partialStop()
	<-s.partialDone
	s.partialDone = nil
}

func (s *Session) fail(id int, code string, err error) {
	s.deps.Logger.Warn("utterance failed", "utterance", id, "code", code, "err", err)
	if s.ctx.Err() != nil {
		return
	}
	s.emitError(code, "processing failed", id)
	s.emitEnd(id, protocol.StatusFailed, code)
}

func (s *Session) emitError(code, msg string, id int) {
	s.emit(protocol.Error{Type: protocol.TypeError, Code: code, Message: msg, UtteranceID: id})
}

func (s *Session) emitEnd(id int, status, reason string) {
	s.emit(protocol.UtteranceEnd{Type: protocol.TypeUtteranceEnd, UtteranceID: id, Status: status, Reason: reason})
}

func (s *Session) emit(v any) {
	if err := s.out.JSON(v); err != nil && s.ctx.Err() == nil {
		s.deps.Logger.Debug("emit failed", "err", err)
	}
}
