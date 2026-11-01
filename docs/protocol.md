# WS protokol v1

`GET /v1/ws`, hlavička `Authorization: Bearer <token>`. Textové rámce jsou JSON s polem `type`, binární rámce nesou audio. Definice: `server/internal/protocol`, `app/packages/translator_core/lib/src/protocol.dart`.

Strany: `a` je majitel telefonu (dolní polovina), `b` kolega (horní, otočená).

## Klient → server

| zpráva | význam |
|---|---|
| `session.start {deviceId, langA, langB, mode, voiceA?, voiceB?, tts?}` | `mode`: `auto`, `ptt`, `streaming` |
| binární rámec | PCM16LE, 16 kHz, mono; přidá se k rozdělané promluvě (max 30 s) |
| `audio.end {side?}` | uzavře promluvu; `side` posílá push-to-talk |
| `audio.cancel` | zahodí rozdělanou promluvu |
| `speaker.force {side}` | přiřadí čekající nejistou promluvu, jinak platí pro další promluvu |
| `session.config {tts}` | zapne nebo vypne hlas |
| `session.end` | konec |

## Server → klient

Pořadí pro jednu promluvu: `asr.final`, `mt.partial`*, `mt.final`, (`tts.start` + binární rámec)*, `tts.end`, `utterance.end`. První klip může přijít před `mt.final`, protože TTS začíná první dokončenou větou.

| zpráva | význam |
|---|---|
| `session.ready {sessionId, protocol}` | session běží |
| `asr.partial {side?, text}` | průběžný přepis, jen `streaming` |
| `asr.final {utteranceId, side?, lang, text, confidence, uncertain}` | `uncertain: true` nemá `side`, nepřekládá se a čeká na `speaker.force` |
| `mt.partial`, `mt.final {utteranceId, side, lang, text}` | `side` je mluvčí, `lang` cílový jazyk |
| `tts.start {utteranceId, seq, format}` | další binární rámec je celý klip jedné věty |
| `tts.end {utteranceId}` | žádný další klip |
| `utterance.end {utteranceId, status, reason?}` | vždy poslední; `ok`, `dropped`, `uncertain`, `failed` |
| `error {code, message, utteranceId?}` | viz níže |

Chybové kódy: `bad_request`, `no_session`, `too_long`, `busy`, `queue_full`, `asr_unavailable`, `mt_unavailable`, `tts_unavailable`. Při `tts_unavailable` zůstává překlad na obrazovce.

## Knihovna hlasů

REST vedle WebSocketu se stejným tokenem, jen když server běží s `VOICE_URL`. Hlas patří zařízení (`device` je `deviceId`).

| volání | význam |
|---|---|
| `POST /v1/voices?device=&name=&consent=true` | tělo PCM16LE, 16 kHz, mono, 10–60 s; bez `consent=true` vrací 422; nejvýš 5 hlasů |
| `GET /v1/voices?device=` | seznam `{id, name, seconds, consentAt}` |
| `DELETE /v1/voices/{id}?device=` | fyzicky smaže nahrávku |

`voiceA` a `voiceB` v `session.start` nesou `clone:<id>` pro hlas toho, kdo mluví. Když klon selže, zazní výchozí hlas jazyka.

## Rozhodnutí o mluvčím

1. `speaker.force` nebo `side` z push-to-talk vždy vítězí.
2. Jistá shoda otisku hlasu (obě strany mají aspoň 2 vzorky, podobnost ≥ 0,6, náskok ≥ 0,1).
3. Vyšší pravděpodobnost jazyka z dvojice, pokud je aspoň 0,6.
4. Jinak nejisté.
