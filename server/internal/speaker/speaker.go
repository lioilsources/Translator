// Package speaker resolves who is talking: language first, then voice
// embeddings when language cannot tell the two sides apart.
package speaker

import (
	"math"

	"translator/server/internal/protocol"
)

const (
	// MinLangConfidence is the plan's threshold: below it for both candidate
	// languages the utterance is uncertain.
	MinLangConfidence = 0.6
	minSamples        = 2
	minSimilarity     = 0.6
	minMargin         = 0.1
)

// Decision is the outcome of attributing one utterance.
type Decision struct {
	Side       protocol.Side // empty when uncertain
	Confidence float64
	Uncertain  bool
	Lang       string // language the utterance was detected in
}

// Tracker keeps a voice centroid per side for one session.
type Tracker struct {
	centroid map[protocol.Side][]float64
	samples  map[protocol.Side]int
}

// NewTracker returns an empty tracker.
func NewTracker() *Tracker {
	return &Tracker{centroid: map[protocol.Side][]float64{}, samples: map[protocol.Side]int{}}
}

// Decide attributes an utterance from language probabilities and an optional
// embedding. A confident voice match outranks language, which is what handles
// code-switching and two people sharing a language.
func (t *Tracker) Decide(langA, langB string, probs map[string]float64, emb []float64) Decision {
	lang, p := langA, probs[langA]
	side := protocol.SideA
	if probs[langB] > p {
		lang, p, side = langB, probs[langB], protocol.SideB
	}
	if voice, sim, ok := t.matchVoice(emb); ok {
		return Decision{Side: voice, Confidence: sim, Lang: lang}
	}
	if langA == langB || p < MinLangConfidence {
		return Decision{Confidence: p, Uncertain: true, Lang: lang}
	}
	return Decision{Side: side, Confidence: p, Lang: lang}
}

// Enroll adds an embedding to a side's running mean.
func (t *Tracker) Enroll(side protocol.Side, emb []float64) {
	if len(emb) == 0 {
		return
	}
	c := t.centroid[side]
	if len(c) != len(emb) {
		t.centroid[side] = append([]float64(nil), emb...)
		t.samples[side] = 1
		return
	}
	n := float64(t.samples[side])
	for i := range c {
		c[i] = (c[i]*n + emb[i]) / (n + 1)
	}
	t.samples[side]++
}

func (t *Tracker) matchVoice(emb []float64) (protocol.Side, float64, bool) {
	if len(emb) == 0 || t.samples[protocol.SideA] < minSamples || t.samples[protocol.SideB] < minSamples {
		return "", 0, false
	}
	a := cosine(t.centroid[protocol.SideA], emb)
	b := cosine(t.centroid[protocol.SideB], emb)
	best, other, side := a, b, protocol.SideA
	if b > a {
		best, other, side = b, a, protocol.SideB
	}
	if best < minSimilarity || best-other < minMargin {
		return "", 0, false
	}
	return side, best, true
}

func cosine(a, b []float64) float64 {
	if len(a) != len(b) {
		return 0
	}
	var dot, na, nb float64
	for i := range a {
		dot += a[i] * b[i]
		na += a[i] * a[i]
		nb += b[i] * b[i]
	}
	if na == 0 || nb == 0 {
		return 0
	}
	return dot / math.Sqrt(na*nb)
}
