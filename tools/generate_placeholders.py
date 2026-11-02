#!/usr/bin/env python3
"""Gera sprites e tiles PROVISÓRIOS em pixel art (assets/sprites e assets/tiles).
Rode a partir de qualquer pasta:  python3 tools/generate_placeholders.py
Substitua os PNGs gerados pela arte final quando existir (mesmo nome/tamanho)."""
import random
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
CH_DIR = ROOT / "assets/sprites/characters"
TI_DIR = ROOT / "assets/tiles"
CH_DIR.mkdir(parents=True, exist_ok=True)
TI_DIR.mkdir(parents=True, exist_ok=True)

BLUE = (58, 108, 196)
GOLD = (214, 178, 70)
DARK = (30, 20, 20)

CHARACTERS = {
    # Miguel: cabelo castanho-escuro curto com franja, camiseta preta
    "miguel": dict(skin=(232, 190, 150), hair=(52, 36, 28), shirt=(28, 28, 32), pants=(62, 72, 104), shoes=(28, 28, 30), style="short", glasses=False),
    # Maria Fernanda: óculos redondos dourados, cabelo castanho até os ombros, camisa azul
    "maria_fernanda": dict(skin=(240, 200, 166), hair=(112, 76, 50), shirt=BLUE, pants=(52, 52, 72), shoes=(235, 235, 235), style="shoulder", glasses=True),
    # Ana Clara e Gabriele: camisa azul; cabelo PROVISÓRIO (a definir)
    "ana_clara": dict(skin=(226, 181, 140), hair=(30, 24, 24), shirt=BLUE, pants=(72, 92, 132), shoes=(235, 235, 235), style="long", glasses=False),
    "gabriele": dict(skin=(246, 206, 176), hair=(150, 100, 52), shirt=BLUE, pants=(42, 42, 52), shoes=(235, 235, 235), style="ponytail", glasses=False),
    "morador": dict(skin=(214, 170, 130), hair=(176, 176, 176), shirt=(204, 96, 72), pants=(110, 84, 60), shoes=(60, 45, 35), style="short", glasses=False),
    "crianca": dict(skin=(232, 190, 150), hair=(30, 24, 24), shirt=(232, 200, 64), pants=(70, 100, 70), shoes=(235, 235, 235), style="short", glasses=False),
}


def rgba(c):
    return c if len(c) == 4 else tuple(c) + (255,)


def shade(c, d):
    return tuple(max(0, min(255, v + d)) for v in c[:3])


def R(img, x0, y0, x1, y1, col):
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            if 0 <= x < 16 and 0 <= y < 24:
                img.putpixel((x, y), rgba(col))


def P(img, x, y, col):
    R(img, x, y, x, y, col)


def draw_view(s, view, f):
    img = Image.new("RGBA", (16, 24), (0, 0, 0, 0))
    step = {0: 0, 1: 1, 2: 0, 3: -1}[f]
    skin, hair, shirt, pants, shoes = s["skin"], s["hair"], s["shirt"], s["pants"], s["shoes"]
    style = s["style"]
    R(img, 4, 22, 11, 23, (0, 0, 0, 70))  # sombra

    # pernas
    if view in ("down", "up"):
        for side, (x0, x1) in enumerate(((5, 7), (8, 10))):
            lift = 1 if (step == 1 and side == 0) or (step == -1 and side == 1) else 0
            R(img, x0, 17, x1, 20 - lift, pants)
            R(img, x0, 21 - lift, x1, 22 - lift, shoes)
    else:
        for x0 in (6 - step, 8 + step):
            R(img, x0, 17, x0 + 1, 20, pants)
            R(img, x0, 21, x0 + 1, 22, shoes)

    # tronco e braços
    if view in ("down", "up"):
        R(img, 4, 10, 11, 16, shirt)
        a = -step
        R(img, 3, 11 + a, 3, 15 + a, shade(shirt, -15))
        R(img, 12, 11 - a, 12, 15 - a, shade(shirt, -15))
        P(img, 3, 16 + a, skin)
        P(img, 12, 16 - a, skin)
    else:
        R(img, 5, 10, 10, 16, shirt)
        R(img, 7 + step, 11, 8 + step, 15, shade(shirt, -25))
        R(img, 7 + step, 16, 8 + step, 16, skin)

    # cabeça
    R(img, 4, 2, 11, 9, skin)

    if view == "down":
        R(img, 3, 1, 12, 3, hair)
        R(img, 4, 4, 11, 4, hair)
        if style == "short":
            R(img, 3, 4, 3, 5, hair); R(img, 12, 4, 12, 5, hair)
        elif style == "shoulder":
            R(img, 3, 4, 3, 12, hair); R(img, 12, 4, 12, 12, hair)
        elif style == "long":
            R(img, 3, 4, 3, 15, hair); R(img, 12, 4, 12, 15, hair)
            R(img, 4, 10, 4, 12, hair); R(img, 11, 10, 11, 12, hair)
        elif style == "ponytail":
            R(img, 3, 4, 3, 6, hair); R(img, 12, 4, 12, 6, hair)
        P(img, 6, 6, DARK); P(img, 9, 6, DARK)
        R(img, 7, 8, 8, 8, (176, 100, 96))
        if s["glasses"]:
            for cx in (6, 9):
                for dx in (-1, 0, 1):
                    for dy in (-1, 0, 1):
                        if (dx, dy) != (0, 0):
                            P(img, cx + dx, 6 + dy, GOLD)
    elif view == "up":
        R(img, 3, 1, 12, 8, hair)
        if style == "shoulder":
            R(img, 4, 9, 11, 11, hair)
        elif style == "long":
            R(img, 3, 9, 12, 14, hair)
        elif style == "ponytail":
            R(img, 7, 9, 8, 14, hair)
        elif style == "short":
            R(img, 4, 9, 11, 9, hair)
    else:  # left
        R(img, 4, 1, 11, 3, hair)
        R(img, 4, 4, 8, 4, hair)
        back_bottom = {"short": 7, "shoulder": 11, "long": 15, "ponytail": 6}[style]
        R(img, 8, 1, 12, back_bottom, hair)
        if style == "ponytail":
            R(img, 12, 5, 13, 12, hair)
        P(img, 5, 6, DARK)
        P(img, 3, 7, skin)
        if s["glasses"]:
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    if (dx, dy) != (0, 0):
                        P(img, 5 + dx, 6 + dy, GOLD)
            P(img, 7, 6, GOLD); P(img, 8, 6, GOLD)
    return img


def make_sheet(s):
    sheet = Image.new("RGBA", (64, 96), (0, 0, 0, 0))
    for row, view in enumerate(["down", "left", "right", "up"]):
        for f in range(4):
            fr = draw_view(s, "left" if view == "right" else view, f)
            if view == "right":
                fr = fr.transpose(Image.FLIP_LEFT_RIGHT)
            sheet.paste(fr, (f * 16, row * 24))
    return sheet


def noise_tile(base, var, size, seed, specks=0, speck=None):
    rnd = random.Random(seed)
    img = Image.new("RGBA", size)
    for y in range(size[1]):
        for x in range(size[0]):
            dv = rnd.randint(-var, var)
            img.putpixel((x, y), tuple(max(0, min(255, b + dv)) for b in base) + (255,))
    for _ in range(specks):
        img.putpixel((rnd.randrange(size[0]), rnd.randrange(size[1])), tuple(speck) + (255,))
    return img


def make_house(name, wall, roof=(168, 82, 56)):
    img = Image.new("RGBA", (64, 64), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    rnd = random.Random(name)
    d.rectangle((2, 4, 61, 21), fill=rgba(roof))
    for y in range(7, 22, 3):
        d.line((2, y, 61, y), fill=rgba(shade(roof, -22)))
    d.line((2, 4, 61, 4), fill=rgba(shade(roof, 30)))
    d.rectangle((2, 22, 61, 24), fill=rgba(shade(roof, -45)))
    d.rectangle((4, 25, 59, 63), fill=rgba(wall))
    d.rectangle((4, 58, 59, 63), fill=rgba(shade(wall, -28)))
    for _ in range(30):  # pintura levemente desgastada
        x, y = rnd.randint(5, 58), rnd.randint(26, 57)
        col = shade(wall, -12) if rnd.random() < 0.6 else shade(wall, 10)
        d.rectangle((x, y, x + rnd.randint(1, 3), y + rnd.randint(0, 2)), fill=rgba(col))
    d.rectangle((26, 42, 36, 63), fill=(112, 72, 46, 255))
    d.rectangle((27, 43, 35, 62), outline=(86, 54, 34, 255))
    d.point((34, 53), fill=(230, 200, 90, 255))
    for x0 in (9, 45):
        d.rectangle((x0, 34, x0 + 11, 45), fill=(232, 232, 226, 255))
        d.rectangle((x0 + 1, 35, x0 + 10, 44), fill=(110, 160, 205, 255))
        d.line((x0 + 5, 35, x0 + 5, 44), fill=(232, 232, 226, 255))
        d.line((x0 + 1, 39, x0 + 10, 39), fill=(232, 232, 226, 255))
    d.rectangle((24, 62, 38, 63), fill=(170, 166, 158, 255))
    return img


def make_wall():
    img = noise_tile((190, 185, 175), 5, (6, 16), 1)
    d = ImageDraw.Draw(img)
    d.rectangle((0, 0, 5, 3), fill=(212, 208, 198, 255))
    d.line((0, 4, 0, 15), fill=(150, 145, 135, 255))
    return img


def make_gate_post():
    img = Image.new("RGBA", (8, 20), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle((0, 0, 7, 2), fill=(218, 213, 203, 255))
    d.rectangle((1, 3, 5, 19), fill=(192, 187, 177, 255))
    d.rectangle((6, 6, 7, 19), fill=(38, 38, 44, 255))  # folha do portão de ferro
    for y in range(7, 19, 3):
        d.point((6, y), fill=(90, 90, 100, 255))
    return img


def make_pole():
    img = Image.new("RGBA", (8, 48), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle((3, 2, 4, 47), fill=(122, 102, 82, 255))
    d.line((3, 2, 3, 47), fill=(140, 120, 98, 255))
    d.rectangle((0, 4, 7, 5), fill=(88, 72, 58, 255))
    d.point((0, 3), fill=(200, 200, 205, 255)); d.point((7, 3), fill=(200, 200, 205, 255))
    return img


def make_tree():
    img = Image.new("RGBA", (28, 36), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle((12, 22, 15, 35), fill=(100, 70, 45, 255))
    d.ellipse((1, 1, 26, 25), fill=(62, 128, 62, 255))
    d.ellipse((4, 3, 15, 13), fill=(84, 154, 76, 255))
    d.ellipse((14, 10, 24, 21), fill=(52, 110, 54, 255))
    d.ellipse((6, 14, 15, 22), fill=(70, 140, 68, 255))
    return img


def make_sidewalk():
    img = noise_tile((190, 186, 176), 5, (16, 16), 3, 6, (170, 166, 156))
    d = ImageDraw.Draw(img)
    d.line((15, 0, 15, 15), fill=(158, 154, 144, 255))
    d.line((0, 15, 15, 15), fill=(158, 154, 144, 255))
    return img


# --- saída ---
for cid, spec in CHARACTERS.items():
    make_sheet(spec).save(CH_DIR / f"{cid}.png")

noise_tile((104, 158, 78), 8, (16, 16), 2, 10, (76, 126, 58)).save(TI_DIR / "grass.png")
noise_tile((88, 88, 94), 6, (16, 16), 4, 8, (110, 110, 116)).save(TI_DIR / "asphalt.png")
make_sidewalk().save(TI_DIR / "sidewalk.png")
make_wall().save(TI_DIR / "wall_v.png")
make_gate_post().save(TI_DIR / "gate_post.png")
make_pole().save(TI_DIR / "pole.png")
make_tree().save(TI_DIR / "tree.png")
for name, wall in {
    "house_amarela": (236, 204, 112), "house_azul": (140, 186, 216), "house_verde": (152, 200, 152),
    "house_salmao": (226, 152, 132), "house_branca": (226, 221, 206),
}.items():
    make_house(name, wall).save(TI_DIR / f"{name}.png")
print("Assets provisórios gerados.")
