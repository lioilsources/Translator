# Tlumočník (pracovní název)

Telefon leží na stole mezi dvěma lidmi. Každý mluví svým jazykem, appka pozná, kdo mluví, přeloží to a nahlas řekne druhému. Protokol: [docs/protocol.md](docs/protocol.md).

## Struktura

```
app/                        Flutter (iOS, Android)
app/packages/translator_core  čistý Dart: protokol, VAD, stav hovoru, řadič
server/                     Go orchestrátor (WebSocket, session, klienti modelů)
workers/asr/                FastAPI + Whisper na GPU + ECAPA
workers/spike/              měření fáze 0
scripts/download_models.sh  modely na SPARK
docker-compose.joda.yml     orchestrátor
docker-compose.spark.yml    ASR worker (spouští broker)
```

## Vývoj

```bash
make test
cd workers/asr && ASR_BACKEND=fake uvicorn app:app --port 8110
cd server && TRANSLATOR_ALLOW_ANON=1 go run ./cmd/translator
cd app && flutter run --profile --dart-define=TRANSLATOR_URL=ws://<mac>:8096/v1/ws
```

Proměnné serveru: `.env.example`. Bez `TRANSLATOR_TOKEN` server odmítne start, pokud není `TRANSLATOR_ALLOW_ANON=1`.

## Provoz na SPARKu

ASR worker, LLM i TTS běží jen přes broker. `tts` je v profilech `llm` a `comfy`, v profilu `director` vrací `ai-audio` 503. Na testy:

```bash
sparkctl exec translator qwen36,tts 30 15 "translator test" -- <příkaz>
```

## Odchylky od plánu

| plán | skutečnost | důvod |
|---|---|---|
| MT a TTS workery | Go volá přímo LiteLLM a `ai-audio` | obě služby už existují, další vrstva by jen přidala latenci |
| gRPC, NATS nebo Redis | HTTP | stejný vzor jako DabingCZ, jedna promluva je jeden požadavek |
| Postgres + sqlc | server bez databáze | bez účtů a billingu není co ukládat; přijde s fází 4 |
| `tts.chunk` | `tts.start` + binární rámec s celou větou | klient přehrává celé klipy ze souborů |
| doplněno | `session.ready`, `mt.partial`, `utterance.end`, `audio.cancel`, `session.config` | klient potřebuje jednoznačný konec promluvy a vypínání zvuku |
| Silero VAD | energetický VAD s adaptivním prahem | plán ho pro v1 připouští |

## Naměřeno 31. 10. 2026 (SPARK)

| krok | výsledek | cíl |
|---|---|---|
| ASR faster-whisper, CPU (CTranslate2 nemá CUDA na aarch64) | 10–14 s | nepoužitelné |
| ASR `whisper-large-v3-turbo`, GPU, promluva 2–5 s | 0,22–0,98 s, první po startu 1,7 s | < 0,8 s |
| detekce jazyka cs/en | ≥ 0,986 | ≥ 0,6 |
| TTS první klip přes `/v1/audio/speech` | 1–2 s | < 0,4 s |
| konec promluvy → první klip, se stubem LLM | 1,4–2,7 s | ~2 s |

TTS brzdí `time.sleep(1.0)` v `_await_job` v AiStack `services/audio/app/main.py`. Vstupem byla řeč z TTS, ne živý hlas u stolu.
