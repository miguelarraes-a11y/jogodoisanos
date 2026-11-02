#!/usr/bin/env python3
"""Arte PROVISÓRIA do minigame de basquete: bola, cesta, Miguel segurando a bola e poses de arremesso."""
from PIL import Image, ImageDraw
import generate_placeholders as g

CH, SPR = g.CH_DIR, g.ROOT / "assets/sprites"
ORANGE, LINE = (214, 110, 40), (110, 50, 20)
spec = g.CHARACTERS["miguel"]
skin, shirt = spec["skin"], spec["shirt"]


def draw_ball(img, x, y):
    for j, row in enumerate(["01110", "11111", "11111", "11111", "01110"]):
        for i, c in enumerate(row):
            if c == "1":
                g.P(img, x + i, y + j, ORANGE)
    for i in range(5):
        g.P(img, x + i, y + 2, LINE)
    g.P(img, x + 2, y, LINE); g.P(img, x + 2, y + 4, LINE)


# bola solta (6x6)
b = Image.new("RGBA", (6, 6), (0, 0, 0, 0)); ImageDraw.Draw(b).ellipse((0, 0, 5, 5), fill=ORANGE + (255,), outline=LINE + (255,)); ImageDraw.Draw(b).line((0, 3, 5, 3), fill=LINE + (255,))
b.save(SPR / "ball.png")


def overlay(img, view):
    if view == "down":
        g.P(img, 5, 14, skin); g.P(img, 11, 14, skin); draw_ball(img, 6, 12)
    elif view == "up":
        draw_ball(img, 10, 14)
    else:
        g.P(img, 4, 15, skin); draw_ball(img, 2, 13)


# Miguel andando segurando a bola (mesmo layout dos outros personagens)
sheet = Image.new("RGBA", (64, 96), (0, 0, 0, 0))
for row, view in enumerate(["down", "left", "right", "up"]):
    for f in range(4):
        v = "left" if view == "right" else view
        fr = g.draw_view(spec, v, f); overlay(fr, v)
        if view == "right":
            fr = fr.transpose(Image.FLIP_LEFT_RIGHT)
        sheet.paste(fr, (f * 16, row * 24))
sheet.save(CH / "miguel_ball.png")

# poses de arremesso, de costas para a câmera: 0 segurando, 1 preparando, 2 arremessando
clear = (0, 0, 0, 0)
poses = Image.new("RGBA", (48, 24), (0, 0, 0, 0))
for i in range(3):
    img = g.draw_view(spec, "up", 0)
    if i == 0:
        draw_ball(img, 10, 13); g.P(img, 9, 15, skin)
    else:
        for y in range(11, 17):
            g.P(img, 3, y, clear); g.P(img, 12, y, clear)
        if i == 1:
            g.R(img, 3, 6, 3, 10, shirt); g.R(img, 12, 6, 12, 10, shirt); g.P(img, 3, 5, skin); g.P(img, 12, 5, skin); draw_ball(img, 6, 0)
        else:
            g.R(img, 3, 0, 3, 10, shirt); g.R(img, 12, 0, 12, 10, shirt); g.R(img, 3, 0, 3, 1, skin); g.R(img, 12, 0, 12, 1, skin)
    poses.paste(img, (i * 16, 0))
poses.save(CH / "miguel_shoot.png")

# cesta: parte de trás (tabela + aro) e da frente (aro + rede). Base = ponto no chão sob o aro (aro a 34 px).
hb = Image.new("RGBA", (28, 48), (0, 0, 0, 0)); d = ImageDraw.Draw(hb)
d.rectangle((4, 0, 23, 11), fill=(236, 236, 230, 255), outline=(70, 70, 78, 255)); d.rectangle((10, 3, 17, 8), outline=(214, 70, 50, 255))
d.rectangle((13, 11, 14, 13), fill=(90, 90, 98, 255)); d.line((7, 13, 20, 13), fill=(224, 110, 40, 255))
hb.save(SPR / "hoop_back.png")
hf = Image.new("RGBA", (28, 48), (0, 0, 0, 0)); d = ImageDraw.Draw(hf)
d.line((6, 14, 21, 14), fill=(224, 110, 40, 255)); d.point((6, 13), fill=(224, 110, 40, 255)); d.point((21, 13), fill=(224, 110, 40, 255))
net = (240, 240, 240, 200)
for x0, x1 in zip(range(8, 21, 3), range(10, 19, 2)):
    d.line((x0, 15, x1, 28), fill=net)
d.line((9, 20, 19, 20), fill=net); d.line((10, 24, 18, 24), fill=net)
hf.save(SPR / "hoop_front.png")
print("Arte do basquete gerada.")
