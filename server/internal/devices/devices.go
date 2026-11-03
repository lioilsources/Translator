// Package devices issues and checks per-device tokens, so a build carries no
// shared secret. Tokens are signed, not stored: every server holding the same
// key accepts them, and a server needs no database.
package devices

import (
	"crypto/hmac"
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"net"
	"net/http"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"
	"unicode"
)

// Tier decides the limits of a device.
type Tier string

const (
	// Public is anyone who installed the app.
	Public Tier = "public"
	// Tester entered the invite code; it may also record voices.
	Tester Tier = "tester"
	// Legacy is a caller with the old shared token; it has no device of its own.
	Legacy Tier = "legacy"
)

// Device is who a request comes from. ID is empty for Legacy.
type Device struct {
	ID   string
	Tier Tier
}

// Bytes of 16 kHz mono PCM16 per second of speech.
const pcmBytesPerSecond = 32000

var idRe = regexp.MustCompile(`^[A-Za-z0-9-]{8,64}$`)

// ValidID reports whether id can name a device. Old clients made up UUIDs.
func ValidID(id string) bool { return idRe.MatchString(id) }

// NewID returns 32 random hex characters.
func NewID() string {
	b := make([]byte, 16)
	if _, err := rand.Read(b); err != nil {
		panic(err)
	}
	return hex.EncodeToString(b)
}

// Issuer signs and checks tokens.
type Issuer struct {
	key []byte
}

// NewIssuer takes the key as hex, at least 32 bytes.
func NewIssuer(hexKey string) (*Issuer, error) {
	key, err := hex.DecodeString(strings.TrimSpace(hexKey))
	if err != nil || len(key) < 32 {
		return nil, errors.New("DEVICE_KEY must be at least 32 bytes as hex (openssl rand -hex 32)")
	}
	return &Issuer{key: key}, nil
}

var b64 = base64.RawURLEncoding

func (i *Issuer) sign(payload string) []byte {
	m := hmac.New(sha256.New, i.key)
	m.Write([]byte(payload))
	return m.Sum(nil)
}

// Issue returns v1.<payload>.<signature> for the device.
func (i *Issuer) Issue(d Device, now time.Time) string {
	payload := d.ID + "|" + string(d.Tier) + "|" + strconv.FormatInt(now.Unix(), 10)
	return "v1." + b64.EncodeToString([]byte(payload)) + "." + b64.EncodeToString(i.sign(payload))
}

// Verify returns the device a token was issued to.
func (i *Issuer) Verify(token string) (Device, bool) {
	parts := strings.Split(token, ".")
	if len(parts) != 3 || parts[0] != "v1" {
		return Device{}, false
	}
	payload, err := b64.DecodeString(parts[1])
	if err != nil {
		return Device{}, false
	}
	sig, err := b64.DecodeString(parts[2])
	if err != nil || !hmac.Equal(sig, i.sign(string(payload))) {
		return Device{}, false
	}
	fields := strings.Split(string(payload), "|")
	if len(fields) != 3 || !ValidID(fields[0]) {
		return Device{}, false
	}
	switch tier := Tier(fields[1]); tier {
	case Public, Tester:
		return Device{ID: fields[0], Tier: tier}, true
	}
	return Device{}, false
}

// ParseDenylist reads blocked device ids, separated by commas or spaces.
func ParseDenylist(list string) map[string]bool {
	deny := map[string]bool{}
	for _, id := range strings.FieldsFunc(list, func(r rune) bool { return r == ',' || unicode.IsSpace(r) }) {
		deny[id] = true
	}
	return deny
}

// Limits for one tier: minutes of speech a day.
type Limits struct {
	PublicMinutes int
	TesterMinutes int
}

func (l Limits) bytes(t Tier) int64 {
	switch t {
	case Public:
		return int64(l.PublicMinutes) * 60 * pcmBytesPerSecond
	case Tester:
		return int64(l.TesterMinutes) * 60 * pcmBytesPerSecond
	}
	return -1 // Legacy: unlimited, as before
}

// Service is the device side of the server: auth, registration and the daily
// meter. The counters live in memory, so each server keeps its own.
type Service struct {
	Issuer *Issuer
	// Shared is the old build-time token; empty turns it off.
	Shared string
	// Invite upgrades a device to Tester; empty turns upgrades off.
	Invite string
	Deny   map[string]bool
	Limits Limits
	// PerIP and PerDay cap registrations in a 24-hour window.
	PerIP, PerDay int
	Now           func() time.Time

	mu       sync.Mutex
	day      string
	used     map[string]int64
	active   map[string]bool
	regStart time.Time
	regIP    map[string]int
	regTotal int
}

func (s *Service) now() time.Time {
	if s.Now != nil {
		return s.Now()
	}
	return time.Now()
}

// Open reports whether no auth is configured at all (local development).
func (s *Service) Open() bool { return s.Issuer == nil && s.Shared == "" }

// Authorize checks the bearer token: a device token or the old shared one.
func (s *Service) Authorize(r *http.Request) (Device, bool) {
	if s.Open() {
		return Device{Tier: Legacy}, true
	}
	got, ok := strings.CutPrefix(r.Header.Get("Authorization"), "Bearer ")
	if !ok || got == "" {
		return Device{}, false
	}
	if s.Shared != "" && subtle.ConstantTimeCompare([]byte(got), []byte(s.Shared)) == 1 {
		return Device{Tier: Legacy}, true
	}
	if s.Issuer == nil {
		return Device{}, false
	}
	d, ok := s.Issuer.Verify(got)
	if !ok || s.Deny[d.ID] {
		return Device{}, false
	}
	return d, true
}

// Enter marks the device's session open; false when it already has one.
func (s *Service) Enter(d Device) bool {
	if d.ID == "" {
		return true
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.active == nil {
		s.active = map[string]bool{}
	}
	if s.active[d.ID] {
		return false
	}
	s.active[d.ID] = true
	return true
}

// Leave ends what Enter started.
func (s *Service) Leave(d Device) {
	if d.ID == "" {
		return
	}
	s.mu.Lock()
	delete(s.active, d.ID)
	s.mu.Unlock()
}

// Spend counts n bytes of incoming speech; false once today's limit is gone.
func (s *Service) Spend(d Device, n int) bool {
	limit := s.Limits.bytes(d.Tier)
	if limit < 0 || d.ID == "" {
		return true
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	if day := s.now().UTC().Format(time.DateOnly); day != s.day || s.used == nil {
		s.day, s.used = day, map[string]int64{}
	}
	if s.used[d.ID]+int64(n) > limit {
		return false
	}
	s.used[d.ID] += int64(n)
	return true
}

// admit counts one registration from ip within the 24-hour window.
func (s *Service) admit(ip string) bool {
	s.mu.Lock()
	defer s.mu.Unlock()
	now := s.now()
	if s.regIP == nil || now.Sub(s.regStart) >= 24*time.Hour {
		s.regStart, s.regIP, s.regTotal = now, map[string]int{}, 0
	}
	if s.regTotal >= s.PerDay || s.regIP[ip] >= s.PerIP {
		return false
	}
	s.regTotal++
	s.regIP[ip]++
	return true
}

// clientIP is the caller as Cloudflare saw it. The orchestrator listens only
// on localhost behind the tunnel, so the header cannot come from the client.
func clientIP(r *http.Request) string {
	if ip := r.Header.Get("CF-Connecting-IP"); ip != "" {
		return ip
	}
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		return r.RemoteAddr
	}
	return host
}

func (s *Service) inviteOK(code string) bool {
	return s.Invite != "" && subtle.ConstantTimeCompare([]byte(code), []byte(s.Invite)) == 1
}

// Issued is the answer to a registration or an upgrade.
type Issued struct {
	Token    string `json:"token"`
	DeviceID string `json:"deviceId"`
	Tier     Tier   `json:"tier"`
}

// Request is the body of POST /v1/devices and /v1/devices/upgrade.
type Request struct {
	Invite string `json:"invite,omitempty"`
	// DeviceID keeps an old client's id (and its voices); only with the
	// shared token, which only our own builds ever had.
	DeviceID string `json:"deviceId,omitempty"`
}

// Register issues a new device. The shared token may carry over its old id.
func (s *Service) Register(r *http.Request, req Request) (Issued, int, error) {
	if s.Issuer == nil {
		return Issued{}, http.StatusNotFound, errors.New("device tokens are off")
	}
	d := Device{ID: NewID(), Tier: Public}
	caller, _ := s.Authorize(r)
	switch {
	case caller.Tier == Legacy && s.Shared != "":
		d.Tier = Tester
		if req.DeviceID != "" {
			if !ValidID(req.DeviceID) {
				return Issued{}, http.StatusBadRequest, errors.New("invalid deviceId")
			}
			d.ID = req.DeviceID
		}
	case !s.admit(clientIP(r)):
		return Issued{}, http.StatusTooManyRequests, errors.New("too many new devices, try tomorrow")
	case req.Invite != "":
		if !s.inviteOK(req.Invite) {
			return Issued{}, http.StatusForbidden, errors.New("wrong invite code")
		}
		d.Tier = Tester
	}
	return Issued{Token: s.Issuer.Issue(d, s.now()), DeviceID: d.ID, Tier: d.Tier}, http.StatusCreated, nil
}

// Upgrade turns a device into a Tester, keeping its id.
func (s *Service) Upgrade(r *http.Request, req Request) (Issued, int, error) {
	if s.Issuer == nil {
		return Issued{}, http.StatusNotFound, errors.New("device tokens are off")
	}
	d, ok := s.Authorize(r)
	if !ok || d.ID == "" {
		return Issued{}, http.StatusUnauthorized, errors.New("unauthorized")
	}
	if !s.inviteOK(req.Invite) {
		return Issued{}, http.StatusForbidden, errors.New("wrong invite code")
	}
	d.Tier = Tester
	return Issued{Token: s.Issuer.Issue(d, s.now()), DeviceID: d.ID, Tier: d.Tier}, http.StatusOK, nil
}

// String is for logs: never the token, only the tier and a short id.
func (d Device) String() string {
	if d.ID == "" {
		return string(d.Tier)
	}
	return fmt.Sprintf("%s:%.8s", d.Tier, d.ID)
}
