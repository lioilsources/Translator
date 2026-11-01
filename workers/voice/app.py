"""Voice cloning worker: a per-device voice library and synthesis in those voices.

POST   /v1/voices?device=&name=&consent=true  body: 16 kHz mono PCM16, 10-60 s
GET    /v1/voices?device=
DELETE /v1/voices/{id}?device=                removes the recording from disk
POST   /v1/synthesize {device, voice, text, language} -> 24 kHz WAV

Recordings are biometric data: nothing is stored without consent and neither
audio nor text is logged. Only the orchestrator reaches this service.
"""
from __future__ import annotations

import hashlib
import io
import json
import os
import re
import shutil
import threading
import time
import uuid
import wave
from pathlib import Path
from typing import Any, Protocol

import numpy as np
from fastapi import FastAPI, HTTPException, Query, Request, Response
from pydantic import BaseModel, Field

SAMPLE_RATE = 16000
OUTPUT_RATE = 24000
MIN_SECONDS, MAX_SECONDS = 10, 60
MAX_VOICES = 5
MAX_CHUNK = 170
VOICE_ID = re.compile(r"^[0-9a-f]{32}$")
ROOT = Path(os.environ.get("VOICES_DIR", "/voices"))


class Engine(Protocol):
    languages: dict[str, str]

    def prepare(self, recording: Path) -> Any: ...

    def speak(self, prepared: Any, text: str, language: str) -> np.ndarray: ...


class FakeEngine:
    """Deterministic engine for tests, no weights."""

    languages = {"cs": "cs", "en": "en"}

    def prepare(self, recording: Path) -> Any:
        return recording.name

    def speak(self, prepared: Any, text: str, language: str) -> np.ndarray:
        return np.zeros(OUTPUT_RATE // 10, dtype=np.float32)


class XttsEngine:
    """XTTS-v2 speaks every language in a voice recorded in any one of them."""

    languages = {c: c for c in ("en", "es", "fr", "de", "it", "pt", "pl", "tr", "ru", "nl", "cs", "ar", "ja", "hu", "ko", "hi")}
    languages["zh"] = "zh-cn"

    def __init__(self) -> None:
        # The licence is accepted by a person, in the deployment, never by default.
        if os.environ.get("COQUI_TOS_AGREED") != "1":
            raise RuntimeError("XTTS needs COQUI_TOS_AGREED=1 from the licence holder")
        from TTS.tts.configs.xtts_config import XttsConfig
        from TTS.tts.models.xtts import Xtts

        path = os.environ.get("XTTS_MODEL", "/models/xtts")
        config = XttsConfig()
        config.load_json(f"{path}/config.json")
        self.model = Xtts.init_from_config(config)
        self.model.load_checkpoint(config, checkpoint_dir=path, use_deepspeed=False)
        self.model.cuda().eval()

    def prepare(self, recording: Path) -> Any:
        return self.model.get_conditioning_latents(
            audio_path=[str(recording)], gpt_cond_len=30, max_ref_length=30,
        )

    def speak(self, prepared: Any, text: str, language: str) -> np.ndarray:
        latent, speaker = prepared
        out = self.model.inference(
            text, language, latent, speaker,
            temperature=0.65, repetition_penalty=5.0, enable_text_splitting=False,
        )
        return np.asarray(out["wav"], dtype=np.float32)


def load_engine() -> Engine:
    name = os.environ.get("VOICE_ENGINE", "xtts")
    if name == "fake":
        return FakeEngine()
    if name == "xtts":
        return XttsEngine()
    raise RuntimeError(f"unknown VOICE_ENGINE {name}")


def chunks(text: str) -> list[str]:
    """Splits at commas, then spaces: XTTS truncates long input."""
    out: list[str] = []
    rest = text.strip()
    while len(rest) > MAX_CHUNK:
        head = rest[:MAX_CHUNK]
        cut = head.rfind(",") + 1 or head.rfind(" ") + 1 or MAX_CHUNK
        out.append(rest[:cut].strip())
        rest = rest[cut:].strip()
    return out + [rest] if rest else out


def to_wav(samples: np.ndarray, rate: int) -> bytes:
    pcm = (np.clip(samples, -1, 1) * 32767).astype(np.int16).tobytes()
    buf = io.BytesIO()
    with wave.open(buf, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(rate)
        w.writeframes(pcm)
    return buf.getvalue()


def device_dir(device: str) -> Path:
    if not device:
        raise HTTPException(status_code=422, detail="device required")
    return ROOT / hashlib.sha256(device.encode()).hexdigest()[:32]


def voice_dir(device: str, voice: str) -> Path:
    path = device_dir(device) / voice
    if not VOICE_ID.match(voice) or not path.is_dir():
        raise HTTPException(status_code=404, detail="unknown voice")
    return path


engine = load_engine()
gpu = threading.Lock()
prepared: dict[Path, Any] = {}
app = FastAPI(title="translator-voice")


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "engine": type(engine).__name__}


def _read_body(request: Request) -> bytes:
    import anyio

    async def read() -> bytes:
        return await request.body()

    return anyio.from_thread.run(read)


@app.post("/v1/voices", status_code=201)
def create(
    request: Request,
    device: str = Query(min_length=8, max_length=64),
    name: str = Query(min_length=1, max_length=40),
    consent: bool = False,
) -> dict:
    if not consent:
        raise HTTPException(status_code=422, detail="consent required")
    home = device_dir(device)
    if home.is_dir() and sum(1 for _ in home.iterdir()) >= MAX_VOICES:
        raise HTTPException(status_code=409, detail="voice library is full")
    pcm = _read_body(request)
    seconds = len(pcm) / (2 * SAMPLE_RATE)
    if len(pcm) % 2 or not MIN_SECONDS <= seconds <= MAX_SECONDS:
        raise HTTPException(status_code=422, detail="recording must be 10-60 s")

    voice = uuid.uuid4().hex
    path = home / voice
    path.mkdir(parents=True, mode=0o700)
    try:
        recording = path / "recording.wav"
        recording.write_bytes(to_wav(np.frombuffer(pcm, dtype=np.int16) / 32768.0, SAMPLE_RATE))
        with gpu:
            prepared[path] = engine.prepare(recording)
        meta = {"id": voice, "name": name, "seconds": round(seconds), "consentAt": int(time.time())}
        (path / "meta.json").write_text(json.dumps(meta, ensure_ascii=False))
    except Exception:
        prepared.pop(path, None)
        shutil.rmtree(path, ignore_errors=True)
        raise
    return meta


@app.get("/v1/voices")
def list_voices(device: str = Query(min_length=8, max_length=64)) -> list[dict]:
    home = device_dir(device)
    metas = [json.loads(p.read_text()) for p in home.glob("*/meta.json")] if home.is_dir() else []
    return sorted(metas, key=lambda m: m["consentAt"])


@app.delete("/v1/voices/{voice}", status_code=204)
def delete(voice: str, device: str = Query(min_length=8, max_length=64)) -> Response:
    path = voice_dir(device, voice)
    prepared.pop(path, None)
    shutil.rmtree(path)
    return Response(status_code=204)


class Synthesis(BaseModel):
    device: str = Field(min_length=8, max_length=64)
    voice: str
    text: str = Field(min_length=1, max_length=2000)
    language: str


@app.post("/v1/synthesize")
def synthesize(req: Synthesis) -> Response:
    path = voice_dir(req.device, req.voice)
    language = engine.languages.get(req.language)
    if language is None:
        raise HTTPException(status_code=422, detail="unsupported language")
    with gpu:
        if path not in prepared:
            prepared[path] = engine.prepare(path / "recording.wav")
        parts = [engine.speak(prepared[path], c, language) for c in chunks(req.text)]
    if not parts:
        raise HTTPException(status_code=422, detail="empty text")
    return Response(to_wav(np.concatenate(parts), OUTPUT_RATE), media_type="audio/wav")
