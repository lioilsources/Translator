package session

import (
	"reflect"
	"testing"
)

func TestSentenceBufferAcrossDeltas(t *testing.T) {
	var b sentenceBuffer
	var got []string
	for _, d := range []string{"Dobrý den, jak ", "se máte? Mně ", "se daří skvěle. Díky"} {
		got = append(got, b.push(d)...)
	}
	want := []string{"Dobrý den, jak se máte?", "Mně se daří skvěle."}
	if !reflect.DeepEqual(got, want) {
		t.Fatalf("%q", got)
	}
	if r := b.flush(); r != "Díky" {
		t.Fatalf("%q", r)
	}
}

func TestSentenceBufferKeepsShortAndDecimals(t *testing.T) {
	var b sentenceBuffer
	if got := b.push("Ano. Stojí to 3.50 eura a je to fajn. "); len(got) != 1 || got[0] != "Ano. Stojí to 3.50 eura a je to fajn." {
		t.Fatalf("%q", got)
	}
}

func TestHallucination(t *testing.T) {
	for text, want := range map[string]bool{
		"Thanks for watching!":                         true,
		"  titulky vytvořil JohnyX ":                   true,
		"Thanks for watching my kids yesterday":        false,
		"Děkuji za sledování, ale to mě nezajímá moc.": false,
	} {
		if got := isHallucination(text); got != want {
			t.Errorf("%q: %v", text, got)
		}
	}
}
