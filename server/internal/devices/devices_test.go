package devices

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

const key = "00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff"

func service(t *testing.T) *Service {
	t.Helper()
	issuer, err := NewIssuer(key)
	if err != nil {
		t.Fatal(err)
	}
	now := time.Date(2026, 11, 3, 10, 0, 0, 0, time.UTC)
	return &Service{
		Issuer: issuer, Shared: "shared", Invite: "pozvanka",
		Limits: Limits{PublicMinutes: 1, TesterMinutes: 2},
		PerIP:  2, PerDay: 3,
		Now: func() time.Time { return now },
	}
}

func bearer(token string) *http.Request {
	r := httptest.NewRequest(http.MethodGet, "/", nil)
	if token != "" {
		r.Header.Set("Authorization", "Bearer "+token)
	}
	return r
}

func TestIssueVerify(t *testing.T) {
	s := service(t)
	tok := s.Issuer.Issue(Device{ID: "abcdef0123456789", Tier: Tester}, s.now())
	d, ok := s.Issuer.Verify(tok)
	if !ok || d.ID != "abcdef0123456789" || d.Tier != Tester {
		t.Fatalf("%v %v", d, ok)
	}
	other, _ := NewIssuer(strings.Repeat("ff", 32))
	if _, ok := other.Verify(tok); ok {
		t.Fatal("another key accepted the token")
	}
	parts := strings.Split(tok, ".")
	forged := parts[0] + "." + b64.EncodeToString([]byte("abcdef0123456789|tester|0")) + "." + parts[2]
	if _, ok := s.Issuer.Verify(forged); ok {
		t.Fatal("changed payload accepted")
	}
	for _, bad := range []string{"", "v1", "v1.a.b", "v2." + parts[1] + "." + parts[2]} {
		if _, ok := s.Issuer.Verify(bad); ok {
			t.Fatalf("accepted %q", bad)
		}
	}
	if _, err := NewIssuer("abcd"); err == nil {
		t.Fatal("short key accepted")
	}
}

func TestAuthorize(t *testing.T) {
	s := service(t)
	tok := s.Issuer.Issue(Device{ID: "abcdef0123456789", Tier: Public}, s.now())
	if d, ok := s.Authorize(bearer(tok)); !ok || d.ID != "abcdef0123456789" {
		t.Fatalf("device token: %v %v", d, ok)
	}
	if d, ok := s.Authorize(bearer("shared")); !ok || d.Tier != Legacy || d.ID != "" {
		t.Fatalf("shared token: %v %v", d, ok)
	}
	for _, bad := range []string{"", "nope", "Shared"} {
		if _, ok := s.Authorize(bearer(bad)); ok {
			t.Fatalf("accepted %q", bad)
		}
	}
	s.Deny = map[string]bool{"abcdef0123456789": true}
	if _, ok := s.Authorize(bearer(tok)); ok {
		t.Fatal("blocked device accepted")
	}
	s.Shared = ""
	if _, ok := s.Authorize(bearer("shared")); ok {
		t.Fatal("shared token works after it was removed")
	}
	if _, ok := (&Service{}).Authorize(bearer("")); !ok {
		t.Fatal("no auth configured should be open")
	}
}

func register(t *testing.T, s *Service, token, ip, body string) (Issued, int) {
	t.Helper()
	r := httptest.NewRequest(http.MethodPost, "/v1/devices", strings.NewReader(body))
	if token != "" {
		r.Header.Set("Authorization", "Bearer "+token)
	}
	r.Header.Set("CF-Connecting-IP", ip)
	w := httptest.NewRecorder()
	s.RegisterHandler().ServeHTTP(w, r)
	var got Issued
	if w.Code < 300 {
		if err := json.Unmarshal(w.Body.Bytes(), &got); err != nil {
			t.Fatal(err)
		}
	}
	return got, w.Code
}

func TestRegister(t *testing.T) {
	s := service(t)
	got, code := register(t, s, "", "1.1.1.1", "")
	if code != http.StatusCreated || got.Tier != Public || len(got.DeviceID) != 32 {
		t.Fatalf("%d %+v", code, got)
	}
	if d, ok := s.Authorize(bearer(got.Token)); !ok || d.ID != got.DeviceID {
		t.Fatal("issued token does not work")
	}
	if got, code := register(t, s, "", "1.1.1.1", `{"invite":"pozvanka"}`); code != http.StatusCreated || got.Tier != Tester {
		t.Fatalf("invite: %d %+v", code, got)
	}
	if _, code := register(t, s, "", "1.1.1.1", ""); code != http.StatusTooManyRequests {
		t.Fatalf("third from one IP: %d", code)
	}
	if _, code := register(t, s, "", "2.2.2.2", `{"invite":"spatne"}`); code != http.StatusForbidden {
		t.Fatalf("wrong invite: %d", code)
	}
	if _, code := register(t, s, "", "3.3.3.3", ""); code != http.StatusTooManyRequests {
		t.Fatalf("over the daily total: %d", code)
	}
	// The shared token skips the limits and keeps its old id, so voices stay.
	old := "6f1c2a9e-0d4b-4c7e-9a51-3b8e2f7d6c10"
	if got, code := register(t, s, "shared", "1.1.1.1", `{"deviceId":"`+old+`"}`); code != http.StatusCreated || got.DeviceID != old || got.Tier != Tester {
		t.Fatalf("migration: %d %+v", code, got)
	}
	// Without the shared token a client cannot claim an id.
	s.PerDay, s.PerIP = 100, 100
	if got, _ := register(t, s, "", "4.4.4.4", `{"deviceId":"`+old+`"}`); got.DeviceID == old {
		t.Fatal("anyone can claim an old id")
	}
	if _, code := register(t, s, "shared", "1.1.1.1", `{"deviceId":"x"}`); code != http.StatusBadRequest {
		t.Fatalf("bad id: %d", code)
	}
}

func TestUpgrade(t *testing.T) {
	s := service(t)
	pub := s.Issuer.Issue(Device{ID: "abcdef0123456789", Tier: Public}, s.now())
	call := func(token, body string) (Issued, int) {
		r := httptest.NewRequest(http.MethodPost, "/v1/devices/upgrade", strings.NewReader(body))
		r.Header.Set("Authorization", "Bearer "+token)
		w := httptest.NewRecorder()
		s.UpgradeHandler().ServeHTTP(w, r)
		var got Issued
		_ = json.Unmarshal(w.Body.Bytes(), &got)
		return got, w.Code
	}
	if _, code := call(pub, `{"invite":"spatne"}`); code != http.StatusForbidden {
		t.Fatalf("wrong invite: %d", code)
	}
	if _, code := call("shared", `{"invite":"pozvanka"}`); code != http.StatusUnauthorized {
		t.Fatalf("shared token has no device: %d", code)
	}
	got, code := call(pub, `{"invite":"pozvanka"}`)
	if code != http.StatusOK || got.Tier != Tester || got.DeviceID != "abcdef0123456789" {
		t.Fatalf("%d %+v", code, got)
	}
	s.Invite = ""
	if _, code := call(pub, `{"invite":""}`); code != http.StatusForbidden {
		t.Fatalf("empty invite code must not upgrade: %d", code)
	}
}

func TestSpendAndEnter(t *testing.T) {
	s := service(t)
	pub := Device{ID: "abcdef0123456789", Tier: Public}
	minute := 60 * pcmBytesPerSecond
	if !s.Spend(pub, minute) || s.Spend(pub, 1) {
		t.Fatal("public: one minute a day")
	}
	if !s.Spend(Device{Tier: Legacy}, 100*minute) {
		t.Fatal("legacy is unlimited")
	}
	next := s.now().Add(24 * time.Hour)
	s.Now = func() time.Time { return next }
	if !s.Spend(pub, minute) {
		t.Fatal("a new day starts from zero")
	}
	if !s.Enter(pub) || s.Enter(pub) {
		t.Fatal("one session per device")
	}
	s.Leave(pub)
	if !s.Enter(pub) {
		t.Fatal("Leave frees the device")
	}
	if !s.Enter(Device{Tier: Legacy}) || !s.Enter(Device{Tier: Legacy}) {
		t.Fatal("legacy callers share no device")
	}
}

func TestDenylist(t *testing.T) {
	deny := ParseDenylist(" abcdef0123456789, 0123456789abcdef\n")
	if !deny["abcdef0123456789"] || !deny["0123456789abcdef"] || len(deny) != 2 {
		t.Fatalf("%v", deny)
	}
	if len(ParseDenylist("")) != 0 {
		t.Fatal("empty list blocks something")
	}
}

func TestMe(t *testing.T) {
	s := service(t)
	tok := s.Issuer.Issue(Device{ID: "abcdef0123456789", Tier: Tester}, s.now())
	w := httptest.NewRecorder()
	s.MeHandler().ServeHTTP(w, bearer(tok))
	if w.Code != http.StatusOK || !strings.Contains(w.Body.String(), `"tier":"tester"`) {
		t.Fatalf("%d %s", w.Code, w.Body)
	}
	w = httptest.NewRecorder()
	s.MeHandler().ServeHTTP(w, bearer("nope"))
	if w.Code != http.StatusUnauthorized {
		t.Fatalf("%d", w.Code)
	}
}
