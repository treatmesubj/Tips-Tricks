import sys
import time
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import ST7789


def get_message():
    if not sys.stdin.isatty():
        return sys.stdin.read()
        # printf "hey\nthere\n" | python3 show_text.py
    else:
        return sys.argv[1]


MESSAGE = get_message()

disp = ST7789.ST7789(
    height=240,
    rotation=90,
    port=0,
    cs=ST7789.BG_SPI_CS_FRONT,  # BG_SPI_CS_BACK or BG_SPI_CS_FRONT
    dc=9,
    backlight=19,               # 18 for back BG slot, 19 for front BG slot.
    spi_speed_hz=80 * 1000 * 1000,
    offset_left=0,
    offset_top=0
)

disp.begin()

WIDTH = disp.width
HEIGHT = disp.height
img = Image.new('RGB', (WIDTH, HEIGHT), color=(0, 0, 0))

draw = ImageDraw.Draw(img)
font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 30)
size_x, size_y = draw.textsize(MESSAGE, font) # width, height of text

draw.rectangle((0, 0, disp.width, disp.height), (0, 0, 0))
draw.text((0, 0), MESSAGE, font=font, fill=(255, 255, 255))
disp.display(img)
