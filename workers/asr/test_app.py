import os

os.environ["ASR_BACKEND"] = "fake"

from fastapi.testclient import TestClient  # noqa: E402

from app import app  # noqa: E402

client = TestClient(app)
PCM = b"\x00\x00" * 16000


def test_candidates_returns_probs():
    r = client.post("/v1/transcribe?candidates=cs,en", content=PCM)
    assert r.status_code == 200
    body = r.json()
    assert body["language"] == "cs" and set(body["probs"]) == {"cs", "en"}


def test_forced_language():
    assert client.post("/v1/transcribe?language=en", content=PCM).json()["probs"] == {"en": 1.0}


def test_requires_language_or_candidates():
    assert client.post("/v1/transcribe", content=PCM).status_code == 422


def test_rejects_odd_body():
    assert client.post("/v1/transcribe?language=en", content=b"\x00").status_code == 422


def test_rejects_oversized_body():
    assert client.post("/v1/transcribe?language=en", content=b"\x00\x00" * (16000 * 32)).status_code == 413
