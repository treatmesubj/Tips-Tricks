### [Pidi-Spotify Repository](https://github.com/pimoroni/pidi-spotify)

# Remove Blur and Overlay From Display
Yes! In `pidi_display_pil/__init__.py` in `DisplayPIL.update_album_art`I just needed to comment out the Gaussian blur at line 125 and in `DisplayPIL.update_overlay` I commented out the `self.update_text_layer()` call in line 135. \
\
Now the display simply shows the buttons, volume, progress bar, & album art, which is perfect for my needs \

# Custom Pidi Display Boot Image
1. I have an image that I want to display at boot: `/home/pi/Pictures/rock.jpg`
2. I create a Python script: `/home/pi/Pictures/pi_lcd_rock.py` \
<b>pi_lcd_rock.py</b>
```python
from PIL import Image, ImageDraw
from ST7789 import ST7789

image = Image.open('/home/pi/Pictures/Rock.jpg').resize((240, 240))
draw = ImageDraw.Draw(image)

st7789 = ST7789(
    rotation=90,  # Needed to display the right way up on Pirate Audio
    port=0,       # SPI port
    cs=1,         # SPI port Chip-select channel
    dc=9,         # BCM pin used for data/command
    backlight=13,
    spi_speed_hz=80 * 1000 * 1000
)

st7789.display(image)
```
3. Add a command to `/etc/rc.local` to execute `/home/pi/Pictures/pi_lcd_rock.py` at Boot
	1. `pi@raspberrypi:~ $ sudo nano /etc/rc.local`
```bash
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

sudo python3 /home/pi/Pictures/pi_lcd_rock.py

exit 0
```