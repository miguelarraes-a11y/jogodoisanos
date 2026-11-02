#!/usr/bin/env python3
"""Gera a arte PROVISÓRIA da Cena 01 (quartos, camas, pijamas, 'dormindo', Kovak).
Uso: python3 tools/generate_bedroom_assets.py"""
from PIL import Image, ImageDraw
import generate_placeholders as g

TI, CH = g.TI_DIR, g.CH_DIR
rgba, shade = g.rgba, g.shade
WOOD = (140, 98, 64)
DARKWOOD = (104, 70, 44)

# ---- pijamas (provisórios) e blusa 'dormindo' ----
PAJAMAS = {
    "miguel": dict(pj=(122, 128, 146), pants=(84, 90, 116), blanket=(96, 128, 176)),
    "maria_fernanda": dict(pj=(214, 172, 202), pants=(196, 150, 186), blanket=(176, 112, 96)),
}
for cid, p in PAJAMAS.items():
    spec = dict(g.CHARACTERS[cid]); spec["shirt"] = p["pj"]; spec["pants"] = p["pants"]; spec["shoes"] = (200, 190, 180)
    g.make_sheet(spec).save(CH / f"{cid}_pijama.png")


def sleeper_frame(cid, state):
    s, p = g.CHARACTERS[cid], PAJAMAS[cid]
    img = Image.new("RGBA", (24, 30), (0, 0, 0, 0)); d = ImageDraw.Draw(img)
    skin, hair, pj, blanket, style = s["skin"], s["hair"], p["pj"], p["blanket"], s["style"]
    longh = style in ("shoulder", "long")
    d.rectangle((3, 0, 20, 8), fill=(250, 250, 248, 255), outline=(214, 214, 210, 255))  # travesseiro
    if longh:
        d.rectangle((6, 2, 17, 9), fill=rgba(hair))
    d.rectangle((8, 2, 15, 9), fill=rgba(skin))
    d.rectangle((8, 1, 15, 4), fill=rgba(hair)); d.rectangle((7, 2, 7, 5), fill=rgba(hair)); d.rectangle((16, 2, 16, 5), fill=rgba(hair))
    if state == "sleep":
        d.line((9, 6, 10, 6), fill=rgba(shade(skin, -70))); d.line((13, 6, 14, 6), fill=rgba(shade(skin, -70)))
    else:
        d.point((10, 6), fill=rgba(g.DARK)); d.point((13, 6), fill=rgba(g.DARK))
    d.line((11, 8, 12, 8), fill=(176, 100, 96, 255))
    top = 19 if state == "sit" else 12
    if state == "sit":
        d.rectangle((5, 10, 18, 19), fill=rgba(pj))
        d.rectangle((3, 11, 4, 18), fill=rgba(shade(pj, -15))); d.rectangle((19, 11, 20, 18), fill=rgba(shade(pj, -15)))
        d.rectangle((3, 19, 4, 19), fill=rgba(skin)); d.rectangle((19, 19, 20, 19), fill=rgba(skin))
        if longh:
            d.rectangle((6, 5, 7, 14), fill=rgba(hair)); d.rectangle((16, 5, 17, 14), fill=rgba(hair))
    else:
        d.rectangle((5, 10, 18, 12), fill=rgba(pj))
    d.rectangle((1, top, 22, 29), fill=rgba(blanket))
    d.line((1, top, 22, top), fill=rgba(shade(blanket, 24)))
    d.rectangle((1, 27, 22, 29), fill=rgba(shade(blanket, -18)))
    return img


for cid in PAJAMAS:
    sheet = Image.new("RGBA", (72, 30))
    for i, st in enumerate(("sleep", "awake", "sit")):
        sheet.paste(sleeper_frame(cid, st), (i * 24, 0))
    sheet.save(CH / f"sleeper_{cid}.png")

# ---- Kovak: vira-lata pequeno, preto e branco (2 frames 22x14: deitado / cabeça levantada) ----
def kovak_frame(head_up):
    img = Image.new("RGBA", (22, 14), (0, 0, 0, 0)); d = ImageDraw.Draw(img)
    black, white = (28, 28, 32, 255), (240, 240, 236, 255)
    d.ellipse((3, 5, 16, 13), fill=black)               # corpo
    d.rectangle((1, 6, 3, 8), fill=black)               # rabo
    d.ellipse((9, 9, 14, 13), fill=white)               # peito branco
    d.rectangle((6, 12, 8, 13), fill=white); d.rectangle((15, 12, 17, 13), fill=white)  # patas
    hy = 0 if head_up else 3
    if head_up:
        d.rectangle((13, 5, 16, 9), fill=black)         # pescoço
    d.ellipse((13, hy + 1, 20, hy + 8), fill=black)     # cabeça
    d.rectangle((17, hy + 5, 20, hy + 8), fill=white)   # focinho branco
    d.rectangle((13, hy, 14, hy + 3), fill=(12, 12, 14, 255))  # orelha
    d.point((17, hy + 4), fill=white)                   # olho
    return img

kv = Image.new("RGBA", (44, 14))
kv.paste(kovak_frame(False), (0, 0)); kv.paste(kovak_frame(True), (22, 0))
kv.save(CH / "kovak.png")

# ---- cenário do quarto ----
g.noise_tile((212, 203, 186), 4, (16, 16), 11, 5, (196, 186, 168)).save(TI / "floor_ceramic.png")
ft = Image.open(TI / "floor_ceramic.png"); fd = ImageDraw.Draw(ft)
fd.line((15, 0, 15, 15), fill=(184, 174, 156, 255)); fd.line((0, 15, 15, 15), fill=(184, 174, 156, 255)); ft.save(TI / "floor_ceramic.png")
g.noise_tile((174, 204, 190), 3, (16, 16), 12, 4, (160, 190, 176)).save(TI / "wall_miguel.png")
g.noise_tile((226, 198, 214), 3, (16, 16), 13, 4, (212, 184, 200)).save(TI / "wall_maria.png")
bb = Image.new("RGBA", (16, 6), (240, 238, 232, 255)); ImageDraw.Draw(bb).line((0, 5, 15, 5), fill=(196, 190, 180, 255)); bb.save(TI / "baseboard.png")


def bed(blanket=None, rumpled=None):
    img = Image.new("RGBA", (28, 40), (0, 0, 0, 0)); d = ImageDraw.Draw(img)
    d.rectangle((0, 0, 27, 39), fill=rgba(WOOD)); d.rectangle((0, 0, 27, 3), fill=rgba(DARKWOOD))
    d.rectangle((2, 4, 25, 37), fill=(238, 236, 230, 255))
    d.rectangle((5, 6, 22, 13), fill=(250, 250, 248, 255), outline=(214, 214, 210, 255))
    d.rectangle((0, 38, 27, 39), fill=rgba(DARKWOOD))
    if blanket:
        d.rectangle((2, 15, 25, 37), fill=rgba(blanket)); d.line((2, 15, 25, 15), fill=rgba(shade(blanket, 26)))
    if rumpled:
        d.rectangle((3, 29, 24, 37), fill=rgba(rumpled)); d.line((3, 29, 24, 29), fill=rgba(shade(rumpled, 26)))
    return img

bed(rumpled=(96, 128, 176)).save(TI / "bed_open.png")
bed(blanket=(96, 128, 176)).save(TI / "bed_made_a.png")
bed(blanket=(150, 170, 120)).save(TI / "bed_made_b.png")

bk = Image.new("RGBA", (32, 60), (0, 0, 0, 0)); d = ImageDraw.Draw(bk)
d.rectangle((3, 7, 28, 33), fill=(238, 236, 230, 255)); d.rectangle((6, 9, 25, 15), fill=(250, 250, 248, 255), outline=(214, 214, 210, 255))
d.rectangle((3, 40, 28, 56), fill=(238, 236, 230, 255)); d.rectangle((6, 41, 25, 45), fill=(250, 250, 248, 255), outline=(214, 214, 210, 255))
d.rectangle((3, 47, 28, 56), fill=(176, 112, 96, 255)); d.line((3, 47, 28, 47), fill=(204, 138, 120, 255))
d.rectangle((0, 0, 2, 59), fill=rgba(WOOD)); d.rectangle((29, 0, 31, 59), fill=rgba(WOOD))
d.rectangle((0, 4, 31, 6), fill=rgba(DARKWOOD)); d.rectangle((0, 34, 31, 36), fill=rgba(WOOD)); d.rectangle((0, 57, 31, 59), fill=rgba(DARKWOOD))
for y in range(14, 58, 6):
    d.line((27, y, 30, y), fill=(176, 128, 84, 255))   # escadinha (lado direito)
bk.save(TI / "bunk_bed.png")

wd = Image.new("RGBA", (24, 44), (0, 0, 0, 0)); d = ImageDraw.Draw(wd)
d.rectangle((0, 0, 23, 43), fill=(150, 104, 70, 255), outline=rgba(DARKWOOD)); d.line((11, 1, 11, 42), fill=rgba(DARKWOOD))
d.rectangle((1, 1, 22, 3), fill=(170, 124, 88, 255)); d.point((9, 22), fill=(220, 200, 120, 255)); d.point((13, 22), fill=(220, 200, 120, 255))
wd.save(TI / "wardrobe.png")

wn = Image.new("RGBA", (24, 24), (0, 0, 0, 0)); d = ImageDraw.Draw(wn)
d.rectangle((0, 0, 23, 23), fill=(236, 236, 230, 255)); d.rectangle((2, 2, 21, 21), fill=(130, 175, 215, 255))
d.line((11, 2, 11, 21), fill=(236, 236, 230, 255)); d.line((2, 11, 21, 11), fill=(236, 236, 230, 255))
d.rectangle((2, 2, 6, 21), fill=(242, 230, 202, 255)); d.rectangle((17, 2, 21, 21), fill=(242, 230, 202, 255))
d.line((0, 1, 23, 1), fill=(120, 96, 70, 255))
wn.save(TI / "window_curtain.png")

dr = Image.new("RGBA", (20, 38), (0, 0, 0, 0)); d = ImageDraw.Draw(dr)
d.rectangle((0, 0, 19, 37), fill=(130, 88, 56, 255), outline=(96, 62, 38, 255))
d.rectangle((3, 3, 16, 15), outline=(104, 68, 42, 255)); d.rectangle((3, 19, 16, 34), outline=(104, 68, 42, 255)); d.point((16, 20), fill=(224, 196, 90, 255))
dr.save(TI / "door_wood.png")

st = Image.new("RGBA", (16, 14), (0, 0, 0, 0)); d = ImageDraw.Draw(st)
d.rectangle((0, 0, 15, 3), fill=(170, 125, 85, 255)); d.rectangle((1, 4, 14, 13), fill=(146, 104, 70, 255)); d.line((2, 8, 13, 8), fill=rgba(DARKWOOD)); d.point((8, 10), fill=(220, 200, 120, 255))
st.save(TI / "side_table.png")

ck = Image.new("RGBA", (8, 8), (0, 0, 0, 0)); d = ImageDraw.Draw(ck)
d.rectangle((1, 2, 6, 7), fill=(200, 60, 60, 255)); d.point((1, 1), fill=(150, 150, 156, 255)); d.point((6, 1), fill=(150, 150, 156, 255))
d.rectangle((2, 3, 5, 6), fill=(240, 240, 236, 255)); d.point((3, 4), fill=(30, 30, 30, 255)); d.point((4, 5), fill=(30, 30, 30, 255))
ck.save(TI / "alarm_clock.png")
print("Arte da Cena 01 gerada.")
