# Anonymous usage statistics

Tlumočník sends a small set of anonymous events through the shared
`ol1n_telemetry` package (<https://github.com/lioilsources/Ol1nTelemetry>,
tag `v0.1.0`), so the owner can see whether new users get to their first
translation, where they give up while waiting, which errors they hit and
which features advanced users never touch. This file is the **event
dictionary**: the constant `appDictionary`
(`app/lib/telemetry/telemetry_dictionary.dart`) and this document list
exactly the same events and properties, and `app/test/telemetry_test.dart`
fails when they drift apart. The plan behind it is
`DevConventions/Prompts/04-PLAN-analytika.md`.

Adding an event or a property is a change to the privacy policy
(`docs/privacy.html`) and to the store privacy answers. Ask the owner first.

## Nothing about speech

The statistics never contain audio, recognised speech, translations, voice
names, transcripts or anything else said or typed in the app. A conversation
is described only by its language pair (two codes from the fixed list in
`app/lib/ui/languages.dart`), its length in seconds, how it ended and the
phase it was in. Errors are a closed list of kinds, never a server message.

The statistics are separate from translation: their own collector, their own
key (`TELEMETRY_KEY`), their own address (`TELEMETRY_HOST`). They never use
the translation server, the device token or the old shared
`TRANSLATOR_TOKEN`, and the translation server never sees them.

## Rules

The rules of `ol1n_telemetry` apply unchanged (package README):

- No persistent identifier. Each session has a random 128-bit id that lives
  in memory; unsent events carry it in the offline queue and it is gone once
  they are sent. The translation device id is never part of an event.
- Cohorts are computed on the device; only bands leave it.
- Only enums, bands and numbers.
- No key, no network: without `TELEMETRY_KEY` and an `https`
  `TELEMETRY_HOST` nothing is recorded or sent, and the settings screen
  hides the toggle.
- The app never waits for the statistics; failures are swallowed.
- Offline queue of at most 500 events, oldest dropped.
- Off means off at once: the toggle in Settings wipes the queue.
- Measuring never steers the app.

The client keeps its few values (`telemetry_*` keys) in the app's existing
`shared_preferences`. `days_band` is `pre` for a phone that already had
saved choices (languages, a device id) before measuring began.

## Configuration

| `--dart-define` | Meaning |
|---|---|
| `TELEMETRY_KEY` | the app's key at the collector; empty → nothing is sent |
| `TELEMETRY_HOST` | the collector's base address, must be `https`; empty → nothing is sent |
| `TELEMETRY_DEBUG` | `true` prints events to the console instead of sending them |

`release-ios.yml` and `release-android.yml` pass both from the GitHub
secrets of the same names. The key, the collector's address and dashboard
links never go into this public repository.

## Receiver and retention

The developer's own collector (StoreMetrics, protocol v1), on the
developer's own server in the EU (Czech Republic); nobody else receives the
events. It keeps the country derived from the connection and does not store
the IP address. Raw events are kept 12 months.

## Activation

The first translation that arrives on this install: the first conversation
line with a translated text. Sent once per install.

## Flow

`translate_start` → `translate_end` is one conversation, from the tap on
Start (before the microphone permission and the device check) to the end of
the conversation screen. `translate_ready` in between says how long the
connection took. Together they answer where people give up while waiting:
before the microphone (`no_mic`), while connecting (`step: connecting`),
after an error (`offline`, `no_gpu`, `busy`, `quota`, `error`), or without
any translation (`cancel`).

## Features

`ptt`, `streaming`, `pause`, `tts_off`, `speaker_force`, `clone_voice`,
`voice_record`, `history`, `transcript_share`, `server_switch`, `invite`.

## Screens

| Route name | Screen |
|---|---|
| `/` | `setup` |
| `/conversation` | `conversation` |
| `/history` | `history` |
| `/transcript` | `transcript` |
| `/voices` | `voices` |
| `/voices/record` | `voice_record` |
| `/settings` | `settings` |

The language picker is a bottom sheet and does not change the screen.

## Common properties

Sent with every event.

| Property | Type | Values |
|---|---|---|
| `app_version` | enum | the app version (`kAppVersion`, checked against `pubspec.yaml`) |
| `platform` | enum | `ios`, `android`, `macos`, `windows`, `linux`, `other` |
| `lang` | enum | the app's UI language, one of `AppLocalizations.supportedLocales` (`cs`, `en`) |
| `session_band` | band | session number: `1`, `2`, `3-5`, `6-10`, `11+` |
| `days_band` | band | days since measuring began: `0`, `1`, `2-6`, `7-29`, `30+`, `pre` |
| `first_session` | bool | the very first session of a new install |
| `tester` | bool | tester build (always `false` for now) |
| `server` | enum | backend in use: `l40s`, `spark`, `custom` (never its address) |

## Events

### `app_open`

Cold start, or a new session after more than 30 minutes in the background.
Answers: what new users do after the first launch, and whether they come back.

| Property | Type | Values |
|---|---|---|
| `start` | enum | `cold`, `resume` |
| `session_band_first` | bool | the first session of this install in its `session_band` |
| `days_band_first` | bool | the first session of this install in its `days_band` |
| `campaign` | campaign | optional; QR campaign of a new install, `^[a-z0-9-]{1,24}$` (not used by this app yet) |

### `screen_view`

A screen appeared. Answers: the path of the first session.

| Property | Type | Values |
|---|---|---|
| `screen` | enum | `setup`, `conversation`, `history`, `transcript`, `voices`, `voice_record`, `settings`, `other` |
| `prev` | enum | the previous screen, or `none` |

### `screen_leave`

A screen was left. Answers: how long people stay where.

| Property | Type | Values |
|---|---|---|
| `screen` | enum | as in `screen_view` |
| `secs` | int | foreground seconds on the screen |
| `actions` | int | app events, feature uses and locked taps during the stay |

### `session_pause`

The app went to the background or is closing. Sent at once. Answers: when
and where people stop.

| Property | Type | Values |
|---|---|---|
| `active_secs` | int | foreground seconds in this session |
| `screen` | enum | the screen at the time, or `none` |
| `screen_secs` | int | foreground seconds on that screen |

### `activation`

The first translation on this install. Once per install. Answers: how many
new users get to a working translation, and how fast.

| Property | Type | Values |
|---|---|---|
| `secs` | int | seconds since this session's `app_open` |

### `feature_use`

The first use of a feature in a session. Answers: what advanced users use.

| Property | Type | Values |
|---|---|---|
| `feature` | enum | `ptt`, `streaming`, `pause`, `tts_off`, `speaker_force`, `clone_voice`, `voice_record`, `history`, `transcript_share`, `server_switch`, `invite` |

### `feature_snapshot`

After `app_open` of the 3rd, 6th and 11th session: which features this
install has ever used. Answers: what advanced users never use.

| Property | Type | Values |
|---|---|---|
| `f_ptt` | bool | push to talk used |
| `f_streaming` | bool | live mode used |
| `f_pause` | bool | a conversation paused |
| `f_tts_off` | bool | voice switched off (text only) |
| `f_speaker_force` | bool | speaker set by hand (long press, "That was me") |
| `f_clone_voice` | bool | a conversation with a recorded voice |
| `f_voice_record` | bool | a voice recorded |
| `f_history` | bool | history opened |
| `f_transcript_share` | bool | a past conversation shared |
| `f_server_switch` | bool | another backend chosen |
| `f_invite` | bool | an invite code redeemed |
| `features_used` | int | how many of them |

### `error_shown`

The user saw an error. Answers: where people struggle.

| Property | Type | Values |
|---|---|---|
| `kind` | enum | `mic_denied`, `connection`, `backend`, `voice`, `busy`, `quota`, `too_long`, `generic`, `invite_wrong`, `invite_unavailable`, `voice_server` |
| `screen` | enum | the screen at the time, or `none` |

`connection` … `generic` group the conversation's error codes the way the
conversation screen shows them (`telemetryErrorKind`).

### `locked_tap`

Something locked was tried. Answers: how many want what needs an invite.

| Property | Type | Values |
|---|---|---|
| `target` | enum | `voice_record` (recording a voice without the tester level) |

### `translate_start`

Start was tapped. Answers: which language pairs are used, and the start of
the wait.

| Property | Type | Values |
|---|---|---|
| `lang_a` | enum | the phone owner's language: `cs`, `en`, `de`, `uk`, `vi`, `pl`, `sk`, `es`, `fr`, `it`, `pt`, `ja`, `zh`, `other` |
| `lang_b` | enum | the colleague's language, same list |

### `translate_end`

The conversation ended (or never started). Answers: where people give up
while waiting, how long conversations last, how often they fail and why.

| Property | Type | Values |
|---|---|---|
| `result` | enum | `ok` (at least one translation), `cancel` (left without one), `error`, `background` (the app was left mid-conversation and not reopened), `no_mic`, `offline` (connection lost), `no_gpu` (speech or translation service unavailable), `busy`, `quota` |
| `secs` | int | foreground seconds from the tap on Start |
| `step` | enum | where it stood: `setup` (before the conversation screen), `connecting`, `listening`, `recording`, `translating`, `speaking`, `paused` |

### `translate_ready`

The conversation is connected and listening. Once per conversation.
Answers: how long the wait for the server is.

| Property | Type | Values |
|---|---|---|
| `ms` | int | milliseconds from opening the conversation screen |
