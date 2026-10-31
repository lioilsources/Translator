"""ASR worker: Whisper with language restricted to a candidate pair.

POST /v1/transcribe?candidates=cs,en | ?language=cs [&partial=true]
Body: raw 16 kHz mono PCM16LE. Response: {text, language, probs, embedding?}.
"""
from __future__ import annotations

import os
import threading
from typing import Protocol

import numpy as np
from fastapi import FastAPI, HTTPException, Query, Request

SAMPLE_RATE = 16000
MAX_BYTES = 31 * SAMPLE_RATE * 2


class Backend(Protocol):
    def transcribe(self, audio: np.ndarray, language: str | None, candidates: list[str],
                   partial: bool) -> dict: ...


class FakeBackend:
    """Deterministic backend for tests and local development without weights."""

    def transcribe(self, audio, language, candidates, partial):
        lang = language or candidates[0]
        probs = {language: 1.0} if language else {c: (0.9 if c == lang else 0.05) for c in candidates}
        return {"text": os.environ.get("ASR_FAKE_TEXT", "Ahoj"), "language": lang, "probs": probs}


class FasterWhisperBackend:
    """CTranslate2 Whisper. The final pass uses large-v3, partials the turbo model."""

    def __init__(self) -> None:
        from faster_whisper import WhisperModel

        device = os.environ.get("ASR_DEVICE", "auto")
        compute = os.environ.get("ASR_COMPUTE", "int8")
        threads = int(os.environ.get("ASR_THREADS", "8"))
        root = os.environ.get("ASR_MODEL_ROOT", "/models/asr")
        kw = {"device": device, "compute_type": compute, "cpu_threads": threads}
        self.final = WhisperModel(f"{root}/{os.environ.get('ASR_MODEL', 'faster-whisper-large-v3-turbo')}", **kw)
        partial = os.environ.get("ASR_PARTIAL_MODEL", "")
        self.partial = WhisperModel(f"{root}/{partial}", **kw) if partial else self.final
        self.lock = threading.Semaphore(int(os.environ.get("ASR_PARALLEL", "2")))

    def transcribe(self, audio, language, candidates, partial):
        model = self.partial if partial else self.final
        with self.lock:
            probs: dict[str, float]
            if language:
                probs = {language: 1.0}
            else:
                _, _, all_probs = model.detect_language(audio=audio)
                seen = dict(all_probs)
                probs = {c: float(seen.get(c, 0.0)) for c in candidates}
                language = max(probs, key=probs.get)
            segments, _ = model.transcribe(
                audio, language=language, task="transcribe",
                beam_size=1 if partial else 5, vad_filter=False,
                condition_on_previous_text=False,
            )
            text = " ".join(s.text.strip() for s in segments if s.no_speech_prob < 0.8)
        return {"text": text.strip(), "language": language, "probs": probs}


class EcapaEmbedder:
    def __init__(self) -> None:
        import torch
        from speechbrain.inference.speaker import EncoderClassifier

        self.torch = torch
        self.model = EncoderClassifier.from_hparams(
            source=os.environ.get("EMBED_MODEL", "/models/speaker/ecapa-voxceleb"),
            run_opts={"device": os.environ.get("EMBED_DEVICE", "cpu")},
        )

    def embed(self, audio: np.ndarray) -> list[float]:
        with self.torch.no_grad():
            out = self.model.encode_batch(self.torch.from_numpy(audio).unsqueeze(0))
        return [round(float(x), 5) for x in out.squeeze().cpu().numpy()]


def load_backend() -> Backend:
    name = os.environ.get("ASR_BACKEND", "hf")
    if name == "fake":
        return FakeBackend()
    if name == "hf":
        from whisper_hf import HfWhisper

        root = os.environ.get("ASR_MODEL_ROOT", "/models/asr")
        return HfWhisper(f"{root}/{os.environ.get('ASR_MODEL', 'whisper-large-v3-turbo')}",
                         os.environ.get("ASR_DEVICE", "cuda"), int(os.environ.get("ASR_PARALLEL", "2")))
    if name == "faster-whisper":
        return FasterWhisperBackend()
    raise RuntimeError(f"unknown ASR_BACKEND {name}")


backend = load_backend()
embedder = EcapaEmbedder() if os.environ.get("EMBED_ENABLED", "0") == "1" else None
app = FastAPI(title="translator-asr")


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "backend": type(backend).__name__, "embedding": embedder is not None}


@app.post("/v1/transcribe")
def transcribe(
    request: Request,
    language: str | None = Query(default=None, pattern="^[a-z]{2,3}$"),
    candidates: str = Query(default=""),
    partial: bool = False,
) -> dict:
    pcm = _read_body(request)
    if not pcm or len(pcm) % 2:
        raise HTTPException(status_code=422, detail="body must be PCM16 samples")
    pair = [c for c in candidates.split(",") if c]
    if not language and not pair:
        raise HTTPException(status_code=422, detail="language or candidates required")
    audio = np.frombuffer(pcm, dtype=np.int16).astype(np.float32) / 32768.0
    out = backend.transcribe(audio, language, pair, partial)
    if embedder is not None and not partial:
        out["embedding"] = embedder.embed(audio)
    return out


def _read_body(request: Request) -> bytes:
    import anyio

    async def read() -> bytes:
        return await request.body()

    pcm = anyio.from_thread.run(read)
    if len(pcm) > MAX_BYTES:
        raise HTTPException(status_code=413, detail="audio too long")
    return pcm
