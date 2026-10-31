#!/usr/bin/env python3
"""Fáze 0: wav → Whisper → LLM → TTS, s měřením každého kroku.

Běží na SPARKu uvnitř lease se službami qwen36,tts:
  spike.py --pairs cs:en,en:cs --out results.json
Vstupní řeč si vyrobí z TTS, takže nepotřebuje nahrávky. MT_API_KEY čte z env.
"""
from __future__ import annotations

import argparse
import io
import json
import os
import subprocess
import time
import urllib.request

import sys

import numpy as np
from faster_whisper import WhisperModel

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "asr"))

GATEWAY = os.environ.get("MT_URL", "http://localhost:8080")
AUDIO = os.environ.get("TTS_URL", "http://localhost:8093")
MODEL_ROOT = os.path.expanduser(os.environ.get("MODELS_ROOT", "~/deploy/Translator/models"))

VOICES = {"cs": "piper:cs_CZ-kasandra-medium", "en": "kokoro:af_heart"}
PHRASES = {
    "cs": [
        "Dobrý den, nevíte, kde je tady nejbližší lékárna?",
        "Včera jsme s dětmi byli na výletě a celou cestu pršelo, ale stejně jsme si to užili.",
        "Můžu vám tykat? Já jsem Olda a tohle je moje žena.",
    ],
    "en": [
        "Good morning, could you tell me where the nearest pharmacy is?",
        "We went on a trip with the kids yesterday and it rained the whole way, but we enjoyed it anyway.",
        "That's a piece of cake, don't worry about it.",
    ],
}


def post(url: str, payload: dict, headers: dict | None = None) -> bytes:
    req = urllib.request.Request(
        url, json.dumps(payload).encode(),
        {"content-type": "application/json", **(headers or {})},
    )
    with urllib.request.urlopen(req, timeout=120) as r:
        return r.read()


def tts(text: str, lang: str) -> tuple[bytes, float]:
    t0 = time.perf_counter()
    data = post(f"{AUDIO}/v1/audio/speech", {
        "input": text, "voice": VOICES[lang], "language": lang, "response_format": "mp3",
    })
    return data, time.perf_counter() - t0


def to_pcm(mp3: bytes) -> np.ndarray:
    out = subprocess.run(
        ["ffmpeg", "-loglevel", "error", "-i", "pipe:0", "-f", "s16le", "-ac", "1", "-ar", "16000", "pipe:1"],
        input=mp3, capture_output=True, check=True,
    ).stdout
    return np.frombuffer(out, dtype=np.int16).astype(np.float32) / 32768.0


def mt(text: str, src: str, dst: str, model: str) -> tuple[str, float]:
    t0 = time.perf_counter()
    headers = {"authorization": "Bearer " + os.environ.get("MT_API_KEY", "")}
    system = (f"You are a simultaneous interpreter. Translate from {src} to {dst}. "
              "Preserve register. Output only the translation.")
    body = json.loads(post(f"{GATEWAY}/v1/chat/completions", {
        "model": model, "temperature": 0.2, "max_tokens": 400,
        "chat_template_kwargs": {"enable_thinking": False},
        "messages": [{"role": "system", "content": system}, {"role": "user", "content": text}],
    }, headers))
    return body["choices"][0]["message"]["content"].strip(), time.perf_counter() - t0


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--pairs", default="cs:en,en:cs")
    ap.add_argument("--asr", default="faster-whisper-large-v3-turbo,faster-whisper-large-v3")
    ap.add_argument("--mt-model", default=os.environ.get("MT_MODEL", "bench-qwen36"))
    ap.add_argument("--no-mt", action="store_true", help="bez LLM: řekne přepis zpět, změří ASR a TTS")
    ap.add_argument("--threads", type=int, default=8)
    ap.add_argument("--out", default="results.json")
    args = ap.parse_args()

    rows = []
    for asr_name in args.asr.split(","):
        t0 = time.perf_counter()
        hf = None
        if asr_name.startswith("whisper-"):
            from whisper_hf import HfWhisper

            hf = HfWhisper(f"{MODEL_ROOT}/asr/{asr_name}")
            hf.transcribe(np.zeros(16000, dtype=np.float32), "en", [], False)  # warm-up
        else:
            model = WhisperModel(f"{MODEL_ROOT}/asr/{asr_name}", device="auto",
                                 compute_type="int8", cpu_threads=args.threads)
        print(f"== {asr_name} načteno za {time.perf_counter() - t0:.1f} s", flush=True)
        for pair in args.pairs.split(","):
            src, dst = pair.split(":")
            for phrase in PHRASES[src]:
                audio = to_pcm(tts(phrase, src)[0])
                dur = len(audio) / 16000
                t0 = time.perf_counter()
                if hf:
                    out = hf.transcribe(audio, None, [src, dst], False)
                    probs, text = out["probs"], out["text"]
                else:
                    _, _, probs = model.detect_language(audio=audio)
                    probs = dict(probs)
                    segs, _ = model.transcribe(audio, language=src, beam_size=5,
                                               condition_on_previous_text=False)
                    text = " ".join(s.text.strip() for s in segs).strip()
                t_asr = time.perf_counter() - t0
                if args.no_mt:
                    translated, t_mt = text, 0.0
                    _, t_tts = tts(text, src)
                else:
                    translated, t_mt = mt(text, src, dst, args.mt_model)
                    _, t_tts = tts(translated, dst)
                row = {
                    "asr": asr_name, "pair": pair, "audio_s": round(dur, 2),
                    "lang_prob": {k: round(float(probs.get(k, 0)), 3) for k in (src, dst)},
                    "asr_s": round(t_asr, 3), "mt_s": round(t_mt, 3), "tts_s": round(t_tts, 3),
                    "total_s": round(t_asr + t_mt + t_tts, 3),
                    "reference": phrase, "heard": text, "translated": translated,
                }
                rows.append(row)
                print(json.dumps(row, ensure_ascii=False), flush=True)
    with io.open(args.out, "w", encoding="utf-8") as f:
        json.dump(rows, f, ensure_ascii=False, indent=2)
    print(json.dumps({"translations": {"ok": len(rows), "failed": 0}}))


if __name__ == "__main__":
    main()
