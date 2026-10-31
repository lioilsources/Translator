#!/usr/bin/env bash
# Stáhne modely z plánu na SPARK. Běží na SPARKu, je opakovatelný (hf navazuje).
# Bez GPU, takže nejde přes broker; modely jen čeká na disku.
set -u
ROOT="${MODELS_ROOT:-$HOME/deploy/Translator/models}"
HF="${HF_BIN:-$HOME/dev/audio/envs/tools/bin/hf}"
mkdir -p "$ROOT"
failed=0

get() { # <repo> <cílová složka> [další argumenty hf]
  local repo=$1 dest=$2; shift 2
  echo "=== $repo → $dest"
  if ! "$HF" download "$repo" --local-dir "$ROOT/$dest" "$@"; then
    echo "!!! SELHALO: $repo"
    failed=$((failed + 1))
  fi
}

# ASR: CTranslate2 pro faster-whisper, PyTorch pro běh na GPU (aarch64 CT2 bývá jen CPU).
get Systran/faster-whisper-large-v3 asr/faster-whisper-large-v3
get mobiuslabsgmbh/faster-whisper-large-v3-turbo asr/faster-whisper-large-v3-turbo
get openai/whisper-large-v3-turbo asr/whisper-large-v3-turbo --exclude '*.bin' --exclude '*.msgpack' --exclude '*.h5' --exclude '*.ot'

# Otisk hlasu mluvčího (fáze 2).
get speechbrain/spkrec-ecapa-voxceleb speaker/ecapa-voxceleb

# MT fallback pro exotické páry. NLLB je CC-BY-NC: jen pokusy, ne placený provoz.
get facebook/nllb-200-3.3B mt/nllb-200-3.3B
get jbochi/madlad400-3b-mt mt/madlad400-3b-mt --exclude '*.gguf'

# TTS: kandidát na klon (fáze 4) a Piper hlasy pro jazyky, které Kokoro neumí.
get SWivid/F5-TTS tts/f5-tts --include 'F5TTS_v1_Base/*'
get rhasspy/piper-voices tts/piper-voices \
  --include 'de/de_DE/thorsten/medium/*' --include 'pl/pl_PL/gosia/medium/*' \
  --include 'sk/sk_SK/lili/medium/*' --include 'uk/uk_UA/ukrainian_tts/medium/*' \
  --include 'vi/vi_VN/vais1000/medium/*'

# hf s více vzory za jedním přepínačem je bere jako jména souborů a hlásí úspěch.
[ "$(du -sm "$ROOT/asr/whisper-large-v3-turbo" | cut -f1)" -gt 1000 ] || { echo "!!! turbo je neúplné"; failed=$((failed + 1)); }

du -sh "$ROOT"/*
echo "HOTOVO, selhalo: $failed"
exit "$failed"
