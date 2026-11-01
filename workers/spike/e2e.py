#!/usr/bin/env python3
"""End-to-end test: speech over the real WebSocket, with latency per utterance.

  e2e.py --sessions 5 --rounds 4 --out e2e.json

Speech comes from the TTS service, so no recordings are needed. Latency runs
from audio.end to each milestone. Reads TRANSLATOR_TOKEN, WS_URL and TTS_URL.
"""
from __future__ import annotations

import argparse
import asyncio
import audioop
import io
import json
import os
import statistics
import time
import urllib.request
import uuid
import wave

import websockets

WS_URL = os.environ.get("WS_URL", "ws://localhost:8096/v1/ws")
TTS_URL = os.environ.get("TTS_URL", "http://localhost:8003")
VOICES = {
    "cs": ("piper-cs-kasandra-medium", "cs_CZ-kasandra-medium", "cs"),
    "en": ("kokoro-82m", "af_heart", "en-us"),
}
PHRASES = [
    ("cs", "Dobrý den, nevíte, kde je tady nejbližší lékárna?"),
    ("en", "Good morning, could you tell me where the nearest pharmacy is?"),
    ("cs", "Včera jsme s dětmi byli na výletě a celou cestu pršelo, ale stejně jsme si to užili."),
    ("en", "That's a piece of cake, don't worry about it."),
    ("cs", "Můžu vám tykat? Já jsem Olda a tohle je moje žena."),
    ("en", "We should probably head back before it gets dark. Are you hungry?"),
    ("cs", "To je mi úplně šumafuk, vyberte si, co chcete."),
    ("en", "I'll have the soup, and could we get the bill when you have a moment?"),
]


def speech(lang: str, text: str) -> bytes:
    model, voice, code = VOICES[lang]
    boundary = uuid.uuid4().hex
    field = json.dumps({"text": text, "language": code, "model": model, "voice": voice})
    body = (f'--{boundary}\r\nContent-Disposition: form-data; name="request"\r\n\r\n'
            f"{field}\r\n--{boundary}--\r\n").encode()
    req = urllib.request.Request(f"{TTS_URL}/synthesize", body,
                                 {"content-type": f"multipart/form-data; boundary={boundary}"})
    with urllib.request.urlopen(req, timeout=60) as r, wave.open(io.BytesIO(r.read())) as w:
        pcm = w.readframes(w.getnframes())
        if w.getsampwidth() != 2:
            pcm = audioop.lin2lin(pcm, w.getsampwidth(), 2)
        if w.getnchannels() == 2:
            pcm = audioop.tomono(pcm, 2, 0.5, 0.5)
        return audioop.ratecv(pcm, 2, 1, w.getframerate(), 16000, None)[0]


async def utter(ws, pcm: bytes) -> dict:
    for i in range(0, len(pcm), 3200):
        await ws.send(pcm[i:i + 3200])
    await ws.send(json.dumps({"type": "audio.end"}))
    start = time.monotonic()
    out: dict = {"clips": 0}
    ms = lambda: round((time.monotonic() - start) * 1000)
    while True:
        frame = await asyncio.wait_for(ws.recv(), 60)
        if isinstance(frame, bytes):
            out["clips"] += 1
            out.setdefault("first_audio_ms", ms())
            continue
        msg = json.loads(frame)
        kind = msg["type"]
        if kind == "asr.final":
            out.update(asr_ms=ms(), side=msg.get("side"), lang=msg["lang"], heard=msg["text"])
        elif kind == "mt.partial":
            out.setdefault("first_text_ms", ms())
        elif kind == "mt.final":
            out.update(mt_ms=ms(), translation=msg["text"])
        elif kind == "error":
            out.setdefault("errors", []).append(msg.get("code"))
        elif kind == "utterance.end":
            out.update(total_ms=ms(), status=msg["status"])
            return out


async def session(n: int, rounds: int, deadline: float | None, clips: list) -> list[dict]:
    results = []
    headers = {"Authorization": f"Bearer {os.environ['TRANSLATOR_TOKEN']}"}
    async with websockets.connect(WS_URL, additional_headers=headers, max_size=None) as ws:
        await ws.send(json.dumps({"type": "session.start", "deviceId": f"e2e-{n}",
                                  "langA": "cs", "langB": "en", "mode": "auto"}))
        json.loads(await ws.recv())
        i = n  # sessions start at different phrases
        while (deadline and time.monotonic() < deadline) or (not deadline and i - n < rounds):
            lang, text = PHRASES[i % len(PHRASES)]
            res = await utter(ws, clips[i % len(PHRASES)])
            res.update(session=n, expected_lang=lang, said=text)
            results.append(res)
            i += 1
            await asyncio.sleep(1.0 if deadline else 0.2)
        await ws.send(json.dumps({"type": "session.end"}))
    return results


def percentile(values: list[int], q: float) -> int:
    return sorted(values)[min(len(values) - 1, int(len(values) * q))]


async def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--sessions", type=int, default=1)
    ap.add_argument("--rounds", type=int, default=len(PHRASES))
    ap.add_argument("--minutes", type=float, default=0)
    ap.add_argument("--out", default="")
    args = ap.parse_args()
    clips = [speech(lang, text) for lang, text in PHRASES]
    deadline = time.monotonic() + args.minutes * 60 if args.minutes else None
    groups = await asyncio.gather(*(session(n, args.rounds, deadline, clips)
                                    for n in range(args.sessions)))
    rows = [r for g in groups for r in g]
    for r in rows[:len(PHRASES)]:
        print(f"[{r.get('asr_ms')}/{r.get('first_audio_ms')}/{r.get('total_ms')} ms {r.get('status')}] "
              f"{r['said']}\n   heard: {r.get('heard')}\n   → {r.get('translation')}")
    good = [r for r in rows if r.get("status") == "ok"]
    summary = {"utterances": len(rows), "ok": len(good),
               "wrong_language": sum(r.get("lang") != r["expected_lang"] for r in rows)}
    for key in ("asr_ms", "first_text_ms", "first_audio_ms", "total_ms"):
        values = [r[key] for r in good if key in r]
        if values:
            summary[key] = {"p50": int(statistics.median(values)), "p95": percentile(values, 0.95),
                            "max": max(values)}
    print(json.dumps(summary, ensure_ascii=False))
    if args.out:
        with open(args.out, "w", encoding="utf-8") as f:
            json.dump({"summary": summary, "rows": rows}, f, ensure_ascii=False, indent=1)


asyncio.run(main())
