#!/usr/bin/env python3
"""Draws the app icon: two speech bubbles facing each other, like the split screen."""
import json
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

SCALE = 4
S = 1024 * SCALE
TOP, BOTTOM = (18, 28, 74), (10, 122, 130)
CREAM, CORAL = (255, 246, 228), (255, 122, 89)


def background() -> Image.Image:
    img = Image.new("RGB", (1, 256))
    for y in range(256):
        t = y / 255
        img.putpixel((0, y), tuple(round(a + (b - a) * t) for a, b in zip(TOP, BOTTOM)))
    return img.resize((S, S), Image.Resampling.BICUBIC)


def bubble(color: tuple, dot: tuple) -> Image.Image:
    """Bubble with its tail at the lower left, on a transparent canvas."""
    layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    u = SCALE
    d.rounded_rectangle((180 * u, 490 * u, 760 * u, 820 * u), radius=140 * u, fill=color)
    d.polygon([(250 * u, 780 * u), (190 * u, 930 * u), (420 * u, 810 * u)], fill=color)
    for x in (340, 470, 600):
        d.ellipse(((x - 38) * u, (655 - 38) * u, (x + 38) * u, (655 + 38) * u), fill=dot)
    return layer


def shadow(layer: Image.Image) -> Image.Image:
    alpha = layer.getchannel("A").filter(ImageFilter.GaussianBlur(14 * SCALE))
    out = Image.new("RGBA", layer.size, (6, 14, 40, 0))
    out.putalpha(alpha.point(lambda a: a * 45 // 100))
    return out


def icon() -> Image.Image:
    img = background().convert("RGBA")
    lower = bubble(CREAM, BOTTOM)
    upper = bubble(CORAL, CREAM).rotate(180)  # the partner reads the top half upside down
    for layer in (upper, lower):
        img.alpha_composite(shadow(layer))
        img.alpha_composite(layer)
    return img.convert("RGB").resize((1024, 1024), Image.Resampling.LANCZOS)


def main(app: Path) -> None:
    art = icon()
    art.save(app / "assets/icon.png")
    ios = app / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    contents = json.loads((ios / "Contents.json").read_text())
    for entry in contents["images"]:
        side = round(float(entry["size"].split("x")[0]) * int(entry["scale"].rstrip("x")))
        art.resize((side, side), Image.Resampling.LANCZOS).save(ios / entry["filename"])
    for density, side in {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}.items():
        art.resize((side, side), Image.Resampling.LANCZOS).save(
            app / f"android/app/src/main/res/mipmap-{density}/ic_launcher.png")


main(Path(sys.argv[1]))
