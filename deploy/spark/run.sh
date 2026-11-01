#!/usr/bin/env bash
# Tlumočník na SPARKu. Spouští výhradně broker, běží jen po dobu lease:
#   sparkctl exec translator qwen36,tts <min> 15 "translator: záloha" -- \
#     ssh spark deploy/Translator/deploy/spark/run.sh
# Hodnoty dodává ~/deploy/Translator/.env (viz deploy/spark/.env.example).
set -euo pipefail
cd "$HOME/deploy/Translator"
set -a; . ./.env; set +a
trap 'kill 0' EXIT

ASR_BACKEND=hf ASR_MODEL_ROOT="$PWD/models/asr" ASR_MODEL=whisper-large-v3-turbo \
EMBED_ENABLED=1 EMBED_MODEL="$PWD/models/speaker/ecapa-voxceleb" \
  .venv/bin/uvicorn --app-dir workers/asr app:app --host 127.0.0.1 --port 8110 &

ASR_URL=http://127.0.0.1:8110 MT_URL=http://127.0.0.1:8080 MT_MODEL=bench-qwen36 \
TTS_URL=http://127.0.0.1:8093 TRANSLATOR_ADDR=127.0.0.1:8094 \
  bin/translator &

cloudflared tunnel --no-autoupdate --url http://127.0.0.1:8094 run &
wait -n
