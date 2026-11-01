import os
import tempfile

os.environ["VOICE_ENGINE"] = "fake"
os.environ["VOICES_DIR"] = tempfile.mkdtemp()

from fastapi.testclient import TestClient  # noqa: E402

import app as worker  # noqa: E402

client = TestClient(worker.app)
PCM = b"\0\0" * worker.SAMPLE_RATE * 12


def create(device="device-1", name="Já", consent="true", body=PCM):
    return client.post("/v1/voices", params={"device": device, "name": name, "consent": consent}, content=body)


def test_consent_is_required_and_nothing_is_stored():
    assert create(device="no-consent", consent="false").status_code == 422
    assert client.get("/v1/voices", params={"device": "no-consent"}).json() == []


def test_recording_length_is_checked():
    assert create(device="short-rec", body=b"\0\0" * 16000).status_code == 422


def test_library_is_per_device_and_delete_erases_the_recording():
    voice = create(device="owner-dev").json()["id"]
    assert [v["id"] for v in client.get("/v1/voices", params={"device": "owner-dev"}).json()] == [voice]
    assert client.get("/v1/voices", params={"device": "other-dev"}).json() == []
    body = {"voice": voice, "text": "Ahoj.", "language": "cs"}
    assert client.post("/v1/synthesize", json={**body, "device": "other-dev"}).status_code == 404
    assert client.delete(f"/v1/voices/{voice}", params={"device": "other-dev"}).status_code == 404

    path = worker.device_dir("owner-dev") / voice
    assert (path / "recording.wav").exists()
    assert client.delete(f"/v1/voices/{voice}", params={"device": "owner-dev"}).status_code == 204
    assert not path.exists()
    assert client.post("/v1/synthesize", json={**body, "device": "owner-dev"}).status_code == 404


def test_synthesize_returns_wav_after_restart():
    voice = create(device="restart-d").json()["id"]
    worker.prepared.clear()
    res = client.post("/v1/synthesize", json={"device": "restart-d", "voice": voice, "text": "Hello.", "language": "en"})
    assert res.status_code == 200 and res.content[:4] == b"RIFF"


def test_unsupported_language_is_rejected():
    voice = create(device="language1").json()["id"]
    res = client.post("/v1/synthesize", json={"device": "language1", "voice": voice, "text": "x", "language": "vi"})
    assert res.status_code == 422


def test_library_is_limited():
    for _ in range(worker.MAX_VOICES):
        assert create(device="full-lib").status_code == 201
    assert create(device="full-lib").status_code == 409


def test_long_text_is_split():
    parts = worker.chunks("slovo, " * 60)
    assert len(parts) > 1 and all(len(p) <= worker.MAX_CHUNK for p in parts)
