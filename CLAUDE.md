# Translator

## Účel
Telefon na stole mezi dvěma lidmi: pozná mluvčího, přeloží a nahlas řekne druhému. Plán: `Prompts/00-TLUMOCNIK_PLAN.md`. Název appky není rozhodnutý, kód na něm nezávisí.

## Build a test
```
make test
cd workers/asr && ASR_BACKEND=fake pytest
```

## Mapa
- `server/`: Go orchestrátor (WS, session, klienti modelů).
- `workers/asr/`: FastAPI + Whisper. `workers/spike/`: měření fáze 0.
- `app/`: Flutter, `app/packages/translator_core`: čistý Dart (protokol, VAD, stav, řadič).
- `docs/protocol.md`: WS protokol. `scripts/download_models.sh`: modely na SPARK.

## Invarianty
- Během TTS a 300 ms po něm se mikrofon zahazuje (`ConversationController`).
- Text překladu jde klientovi vždy dřív než zvuk a výpadek TTS ho nesmaže.
- `utterance.end` je vždy poslední zpráva promluvy; klient na ní závisí.
- Rámce jedné promluvy se nesmí proložit, proto vše běží přes frontu session.
- Audio ani texty hovorů se na serveru neukládají ani nelogují.
- TTS jen s komerčně čistou licencí (`commercial_only`).

## Odchylky
Odchylka od plánu: viz „Odchylky od plánu“ v README.

## Kam dál
README, `docs/`, `Prompts/`.
