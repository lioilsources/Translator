package session

import (
	"strings"
	"unicode"
)

// sentenceBuffer cuts a growing stream of text into complete sentences so TTS
// can start on the first one while the rest is still being translated.
type sentenceBuffer struct {
	pending strings.Builder
}

const minSentenceRunes = 12

// push appends a delta and returns every sentence completed by it.
func (b *sentenceBuffer) push(delta string) []string {
	b.pending.WriteString(delta)
	var out []string
	rest := []rune(b.pending.String())
	start := 0
	for i, r := range rest {
		if !isTerminator(r) || i+1 >= len(rest) || !unicode.IsSpace(rest[i+1]) {
			continue
		}
		if i+1-start < minSentenceRunes {
			continue // keep "Ano." or "Dr." glued to what follows
		}
		out = append(out, strings.TrimSpace(string(rest[start:i+1])))
		start = i + 1
	}
	b.pending.Reset()
	b.pending.WriteString(string(rest[start:]))
	return out
}

// flush returns the remaining text once the stream has ended.
func (b *sentenceBuffer) flush() string {
	s := strings.TrimSpace(b.pending.String())
	b.pending.Reset()
	return s
}

func isTerminator(r rune) bool {
	switch r {
	case '.', '!', '?', '…', '。', '！', '？':
		return true
	}
	return false
}

// Whole-utterance matches only, so real speech containing these words survives.
var hallucinations = map[string]bool{
	"thanks for watching":                  true,
	"thank you for watching":               true,
	"please subscribe":                     true,
	"subtitles by the amara org community": true,
	"titulky vytvořil johnyx":              true,
	"titulky vytvořil":                     true,
	"děkuji za sledování":                  true,
	"díky za sledování":                    true,
	"untertitel der amara org community":   true,
	"untertitelung des zdf":                true,
	"vielen dank fürs zuschauen":           true,
}

func isHallucination(text string) bool {
	return hallucinations[normalize(text)]
}

func normalize(text string) string {
	var b strings.Builder
	space := false
	for _, r := range strings.ToLower(text) {
		switch {
		case unicode.IsLetter(r) || unicode.IsDigit(r):
			if space && b.Len() > 0 {
				b.WriteByte(' ')
			}
			space = false
			b.WriteRune(r)
		default:
			space = true
		}
	}
	return b.String()
}
