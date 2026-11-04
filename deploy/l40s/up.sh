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
[ -f .env ] || { umask 077; touch .env; }
# Klíč tokenů zařízení. SPARK musí mít stejný, jinak tam tokeny neplatí.
grep -q '^DEVICE_KEY=.' .env || { umask 077; echo "DEVICE_KEY=$(openssl rand -hex 32)" >> .env; }
docker compose up -d --build "$@"
