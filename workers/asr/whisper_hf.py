"""Whisper on GPU via transformers. CTranslate2 has no CUDA build for aarch64."""
from __future__ import annotations

import threading

import numpy as np


class HfWhisper:
    def __init__(self, path: str, device: str = "cuda", parallel: int = 2) -> None:
        import torch
        from transformers import AutoProcessor, WhisperForConditionalGeneration

        self.torch = torch
        self.device = device
        self.dtype = torch.float16 if device == "cuda" else torch.float32
        self.processor = AutoProcessor.from_pretrained(path)
        self.model = WhisperForConditionalGeneration.from_pretrained(
            path, torch_dtype=self.dtype).to(device).eval()
        self.lang_ids = dict(zip(
            self.model.generation_config.lang_to_id.keys(),
            self.model.generation_config.lang_to_id.values(),
        ))
        self.lock = threading.Semaphore(parallel)

    def _features(self, audio: np.ndarray):
        feats = self.processor(audio, sampling_rate=16000, return_tensors="pt").input_features
        return feats.to(self.device, self.dtype)

    def language_probs(self, features, candidates: list[str]) -> dict[str, float]:
        """Probabilities over all Whisper languages, read for the candidates."""
        start = self.model.generation_config.decoder_start_token_id
        ids = self.torch.tensor([[start]], device=self.device)
        logits = self.model(input_features=features, decoder_input_ids=ids).logits[0, -1]
        all_ids = self.torch.tensor(list(self.lang_ids.values()), device=self.device)
        probs = logits[all_ids].float().softmax(-1)
        by_token = dict(zip(self.lang_ids.keys(), probs.tolist()))
        return {c: by_token.get(f"<|{c}|>", 0.0) for c in candidates}

    def transcribe(self, audio, language, candidates, partial):
        with self.lock, self.torch.inference_mode():
            feats = self._features(audio)
            if language:
                probs = {language: 1.0}
            else:
                probs = self.language_probs(feats, candidates)
                language = max(probs, key=probs.get)
            ids = self.model.generate(
                feats, language=language, task="transcribe",
                num_beams=1, max_new_tokens=200,
            )
            text = self.processor.batch_decode(ids, skip_special_tokens=True)[0]
        return {"text": text.strip(), "language": language, "probs": probs}
