#!/usr/bin/env python3
"""Gera áudio PROVISÓRIO e ORIGINAL (sintetizado): despertador, ambiente de casa e música calma.
Uso: python3 tools/generate_placeholder_audio.py   (substitua pelos arquivos finais quando existirem)"""
import wave
from pathlib import Path
import numpy as np

OUT = Path(__file__).resolve().parents[1] / "assets/audio"
OUT.mkdir(parents=True, exist_ok=True)
SR = 22050


def save(name, data):
    d = np.clip(data, -1, 1)
    with wave.open(str(OUT / f"{name}.wav"), "wb") as wf:
        wf.setnchannels(1); wf.setsampwidth(2); wf.setframerate(SR)
        wf.writeframes((d * 32767).astype("<i2").tobytes())


def tone(f, dur, amp=1.0, harm=(1.0, 0.3)):
    t = np.arange(int(dur * SR)) / SR
    w = sum(h * np.sin(2 * np.pi * f * (i + 1) * t) for i, h in enumerate(harm))
    return amp * w


# despertador: 4 bipes rápidos + pausa, 6 repetições (loop é feito pelo jogo)
period = np.zeros(SR)
pos = 0
for _ in range(4):
    b = tone(2000, 0.07, 0.35, (1.0, 0.0, 0.3))
    b *= np.minimum(1, np.arange(len(b)) / 60) * np.minimum(1, (len(b) - np.arange(len(b))) / 60)
    period[pos:pos + len(b)] += b
    pos += int(0.12 * SR)
save("alarm", np.tile(period, 6))

# ambiente doméstico: ruído suave + tique-taque de relógio ao longe
rng = np.random.default_rng(7)
n = 12 * SR
brown = np.cumsum(rng.normal(0, 1, n)); brown -= np.convolve(brown, np.ones(2000) / 2000, mode="same")
brown = brown / np.max(np.abs(brown)) * 0.06
for k in range(12):
    for off, f in ((0.0, 1300), (0.5, 1000)):
        i = int((k + off) * SR)
        t = np.arange(int(0.012 * SR)) / SR
        brown[i:i + len(t)] += 0.10 * np.sin(2 * np.pi * f * t) * np.exp(-t / 0.003)
save("ambient_room", brown)

# música calma e nostálgica (C – Am – F – G), ~27 s
BPM = 72; beat = 60 / BPM
mf = lambda m: 440.0 * 2 ** ((m - 69) / 12)
chords = [[48, 55, 60, 64], [45, 52, 57, 60], [41, 48, 53, 57], [43, 50, 55, 59]]
melody = [[(0, 76), (2, 79), (3, 76)], [(0, 72), (1.5, 76), (3, 74)], [(0, 72), (2, 77), (3, 76)], [(0, 74), (2, 71), (3, 74)]]
total = int((8 * 4 * beat + 3) * SR)
mix = np.zeros(total)


def add(sig, start):
    i = int(start * SR); mix[i:i + len(sig)] += sig[:max(0, total - i)]


def pluck(f, dur, amp):
    t = np.arange(int(dur * SR)) / SR
    env = np.exp(-t / 0.55) * (1 - np.exp(-t / 0.006))
    return amp * env * (np.sin(2 * np.pi * f * t) + 0.35 * np.sin(4 * np.pi * f * t) * np.exp(-t / 0.2) + 0.12 * np.sin(6 * np.pi * f * t))


for rep in range(2):
    for ci, ch in enumerate(chords):
        t0 = (rep * 4 + ci) * 4 * beat
        for j, idx in enumerate([0, 1, 2, 3, 2, 1, 2, 1]):
            add(pluck(mf(ch[idx]), 1.6, 0.11), t0 + j * beat / 2)
        for note in ch[1:]:
            pad = tone(mf(note + 12), 4 * beat + 0.6, 0.035, (1.0, 0.2))
            L = len(pad); env = np.minimum(1, np.arange(L) / (1.2 * SR)) * np.minimum(1, (L - np.arange(L)) / (1.0 * SR))
            add(pad * env, t0)
        for b, m in melody[ci]:
            add(pluck(mf(m), 2.2, 0.16), t0 + b * beat)
mix = mix / np.max(np.abs(mix)) * 0.55
fade = int(2 * SR); mix[-fade:] *= np.linspace(1, 0, fade)
save("music_prologue", mix)
print("Áudio provisório gerado.")
