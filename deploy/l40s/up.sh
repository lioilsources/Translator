#!/usr/bin/env bash
# Stáhne ASR a otisk hlasu z Hugging Face (jednou) a spustí Translator.
set -euo pipefail
cd "$(dirname "$0")"
M=/srv/work/translator-models
HF="$HOME/.local/bin/hf"
[ -f "$M/asr/whisper-large-v3-turbo/model.safetensors" ] ||
  "$HF" download openai/whisper-large-v3-turbo --local-dir "$M/asr/whisper-large-v3-turbo" \
    --exclude '*.bin' --exclude '*.msgpack' --exclude '*.h5' --exclude '*.ot'
[ -f "$M/speaker/ecapa-voxceleb/embedding_model.ckpt" ] ||
  "$HF" download speechbrain/spkrec-ecapa-voxceleb --local-dir "$M/speaker/ecapa-voxceleb"
[ -f .env ] || { umask 077; echo "TRANSLATOR_TOKEN=$(openssl rand -hex 24)" > .env; }
docker compose up -d --build "$@"
