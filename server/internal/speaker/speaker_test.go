package speaker

import (
	"testing"

	"translator/server/internal/protocol"
)

func TestLanguageDecides(t *testing.T) {
	d := NewTracker().Decide("cs", "en", map[string]float64{"cs": .1, "en": .8}, nil)
	if d.Side != protocol.SideB || d.Uncertain || d.Lang != "en" {
		t.Fatalf("%+v", d)
	}
}

func TestBothBelowThresholdUncertain(t *testing.T) {
	d := NewTracker().Decide("cs", "en", map[string]float64{"cs": .55, "en": .4}, nil)
	if !d.Uncertain || d.Side != "" {
		t.Fatalf("%+v", d)
	}
}

func TestSameLanguageNeedsVoice(t *testing.T) {
	d := NewTracker().Decide("cs", "cs", map[string]float64{"cs": .99}, nil)
	if !d.Uncertain {
		t.Fatalf("%+v", d)
	}
}

func enrolled() *Tracker {
	t := NewTracker()
	for range 2 {
		t.Enroll(protocol.SideA, []float64{1, 0})
		t.Enroll(protocol.SideB, []float64{0, 1})
	}
	return t
}

func TestVoiceResolvesCodeSwitch(t *testing.T) {
	// Speaker A switches into English: the voice wins, language stays en.
	d := enrolled().Decide("cs", "en", map[string]float64{"cs": .05, "en": .9}, []float64{1, .05})
	if d.Side != protocol.SideA || d.Lang != "en" {
		t.Fatalf("%+v", d)
	}
}

func TestAmbiguousVoiceFallsBackToLanguage(t *testing.T) {
	d := enrolled().Decide("cs", "en", map[string]float64{"cs": .9}, []float64{1, 1})
	if d.Side != protocol.SideA || d.Confidence != .9 {
		t.Fatalf("%+v", d)
	}
}

func TestNotEnrolledIgnoresVoice(t *testing.T) {
	tr := NewTracker()
	tr.Enroll(protocol.SideA, []float64{1, 0})
	d := tr.Decide("cs", "en", map[string]float64{"en": .9}, []float64{1, 0})
	if d.Side != protocol.SideB {
		t.Fatalf("%+v", d)
	}
}
