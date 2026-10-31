// Package protocol defines the WebSocket wire format (see docs/protocol.md).
package protocol

// Version is bumped on breaking wire changes.
const Version = 1

// Side identifies a participant: A is the phone owner (bottom half), B the
// colleague (top half, rotated).
type Side string

const (
	SideA Side = "a"
	SideB Side = "b"
)

// Other returns the opposite side.
func (s Side) Other() Side {
	if s == SideA {
		return SideB
	}
	return SideA
}

// Valid reports whether s is a known side.
func (s Side) Valid() bool { return s == SideA || s == SideB }

// Mode selects how the client segments speech.
type Mode string

const (
	ModeAuto      Mode = "auto"
	ModePTT       Mode = "ptt"
	ModeStreaming Mode = "streaming"
)

// Client to server message types.
const (
	TypeSessionStart  = "session.start"
	TypeSessionConfig = "session.config"
	TypeSessionEnd    = "session.end"
	TypeAudioEnd      = "audio.end"
	TypeAudioCancel   = "audio.cancel"
	TypeSpeakerForce  = "speaker.force"
)

// Server to client message types.
const (
	TypeSessionReady = "session.ready"
	TypeASRPartial   = "asr.partial"
	TypeASRFinal     = "asr.final"
	TypeMTPartial    = "mt.partial"
	TypeMTFinal      = "mt.final"
	TypeTTSStart     = "tts.start"
	TypeTTSEnd       = "tts.end"
	TypeUtteranceEnd = "utterance.end"
	TypeError        = "error"
)

// Utterance outcomes reported by utterance.end.
const (
	StatusOK        = "ok"
	StatusDropped   = "dropped"
	StatusUncertain = "uncertain"
	StatusFailed    = "failed"
)

// Error codes.
const (
	ErrBadRequest     = "bad_request"
	ErrNoSession      = "no_session"
	ErrTooLong        = "too_long"
	ErrBusy           = "busy"
	ErrQueueFull      = "queue_full"
	ErrASRUnavailable = "asr_unavailable"
	ErrMTUnavailable  = "mt_unavailable"
	ErrTTSUnavailable = "tts_unavailable"
)

// Envelope carries only the type; the full frame is decoded a second time.
type Envelope struct {
	Type string `json:"type"`
}

// SessionStart opens a session on an established connection.
type SessionStart struct {
	Type     string `json:"type"`
	DeviceID string `json:"deviceId"`
	LangA    string `json:"langA"`
	LangB    string `json:"langB"`
	Mode     Mode   `json:"mode"`
	VoiceA   string `json:"voiceA,omitempty"`
	VoiceB   string `json:"voiceB,omitempty"`
	TTS      *bool  `json:"tts,omitempty"`
}

// SessionConfig changes runtime options.
type SessionConfig struct {
	Type string `json:"type"`
	TTS  *bool  `json:"tts,omitempty"`
}

// AudioEnd closes the buffered utterance. Side is set in push-to-talk.
type AudioEnd struct {
	Type string `json:"type"`
	Side Side   `json:"side,omitempty"`
}

// SpeakerForce assigns the waiting uncertain utterance, or the next one.
type SpeakerForce struct {
	Type string `json:"type"`
	Side Side   `json:"side"`
}

// SessionReady acknowledges session.start.
type SessionReady struct {
	Type      string `json:"type"`
	SessionID string `json:"sessionId"`
	Protocol  int    `json:"protocol"`
}

// ASRPartial is an interim transcript. Side is empty until known.
type ASRPartial struct {
	Type string `json:"type"`
	Side Side   `json:"side,omitempty"`
	Text string `json:"text"`
}

// ASRFinal is the final transcript of an utterance.
type ASRFinal struct {
	Type        string  `json:"type"`
	UtteranceID int     `json:"utteranceId"`
	Side        Side    `json:"side,omitempty"`
	Lang        string  `json:"lang"`
	Text        string  `json:"text"`
	Confidence  float64 `json:"confidence"`
	Uncertain   bool    `json:"uncertain"`
}

// MTText is the mt.partial and mt.final payload; Side is the speaker.
type MTText struct {
	Type        string `json:"type"`
	UtteranceID int    `json:"utteranceId"`
	Side        Side   `json:"side"`
	Lang        string `json:"lang"`
	Text        string `json:"text"`
}

// TTSStart precedes one binary frame holding a complete audio clip.
type TTSStart struct {
	Type        string `json:"type"`
	UtteranceID int    `json:"utteranceId"`
	Seq         int    `json:"seq"`
	Format      string `json:"format"`
}

// TTSEnd says no more clips follow for the utterance.
type TTSEnd struct {
	Type        string `json:"type"`
	UtteranceID int    `json:"utteranceId"`
}

// UtteranceEnd is always the last message of an utterance.
type UtteranceEnd struct {
	Type        string `json:"type"`
	UtteranceID int    `json:"utteranceId"`
	Status      string `json:"status"`
	Reason      string `json:"reason,omitempty"`
}

// Error reports a failure. UtteranceID is 0 outside an utterance.
type Error struct {
	Type        string `json:"type"`
	Code        string `json:"code"`
	Message     string `json:"message"`
	UtteranceID int    `json:"utteranceId,omitempty"`
}
