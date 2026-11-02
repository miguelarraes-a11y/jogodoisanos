#!/usr/bin/env python3
"""Efeitos PROVISÓRIOS do basquete (sintetizados): quique, rede, aro, lançamento."""
import wave
from pathlib import Path
import numpy as np

OUT = Path(__file__).resolve().parents[1] / "assets/audio"
SR = 22050
rng = np.random.default_rng(3)


def save(name, data):
    d = np.clip(data, -1, 1)
    with wave.open(str(OUT / f"{name}.wav"), "wb") as wf:
        wf.setnchannels(1); wf.setsampwidth(2); wf.setframerate(SR)
        wf.writeframes((d * 32767).astype("<i2").tobytes())


def hp(x, k=30):
    return x - np.convolve(x, np.ones(k) / k, mode="same")


t = np.arange(int(0.18 * SR)) / SR
f = 110 * np.exp(-t / 0.05) + 55
save("ball_bounce", 0.9 * np.sin(np.cumsum(2 * np.pi * f / SR)) * np.exp(-t / 0.05))

t = np.arange(int(0.4 * SR)) / SR
save("swish", 0.45 * hp(rng.normal(0, 1, len(t))) * np.sin(np.pi * t / 0.4) ** 2)

t = np.arange(int(0.5 * SR)) / SR
save("rim_clank", 0.3 * sum(np.sin(2 * np.pi * fr * t) for fr in (900, 1450, 2300)) * np.exp(-t / 0.12))

t = np.arange(int(0.16 * SR)) / SR
save("throw", 0.3 * hp(rng.normal(0, 1, len(t)), 12) * np.exp(-t / 0.06))
print("Áudio do basquete gerado.")
