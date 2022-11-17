## Watching Videos on a 1" Raspberry Pi Zero W LCD Display

<p align="center">
  <img src="../attachments/pi0w_LCD_vid_demo.gif"/> <a href="https://www.youtube.com/watch?v=Z2iemmzBF1A"><img src="../attachments/pi0_youtube_vid2.png"/></a>
</p>

This is my Raspberry Pi Zero W with a Pirate Audio hat on it, which has a ST7789 240x240 LCD display and an audio jack. The display is being driven by the very cool [juj/fbcp-ili9341](https://github.com/juj/fbcp-ili9341). I've got Raspberry Pi OS Lite booting to `/dev/tty1`, which `~/.bashrc` checks, then spawns and attaches to a `tmux` session. I can `ssh` into my Pi's own wifi network spun up via the very cool [cjimti/iotwifi](https://github.com/cjimti/iotwifi) Docker container ([my tweaks](<./wifi_and_WAP.md>)), attach to the session from there too, and display a shared terminal session on the Pi's LCD. The Pi can connect to an actual network, too. \
For more info about how that works, see [my last project](./fbcp-ili9341-SPI-Display-Pirate-Audio.md), which I'm building off for this one.

### [Teletypes, Pseudo-Terminal Slaves, & X Window System](https://unix.stackexchange.com/a/336527)
My Pi has no Desktop Environment Graphical User Interface (GUI). It's got no mouse or keyboard either. It does have a hardware display: the 1" LCD. The distinction between a `tty` and a `pts` will be relevant later when I want to display images/videos on the Pi's LCD screen.

On Linux, you've got a few instances of Teletypes (`tty`s). In short, a `tty` is a text input/output environment. A `tty` is a console: a hardware display-screen, hardware keyboard, & software command-line-interface/shell to interact with the kernel (the interface to control the hardware) via issuance of typed out commands which the kernel executes and then writes any relevant output or errors to the display. On 1 computer with 1 kernel, 1 keyboard, & 1 display, you can have multiple `tty`s which you can switch between. On a typical desktop computer which has a Linux distribution installed, one of the `tty`s runs a command to launch a process to spawn the familar GUI desktop environment with your wallpaper, mouse-pointer/cursor, files, etc, and the actual `tty` command-line-interface/shell under it all is never seen.

A Pseudo-Terminal Slave (`pts`) is like a `tty` but without the physical display & keyboard hardware. I'll be using a `pts` on the Pi from a remote device via the secure shell protocol (`ssh`).\
Also, I'll have a `tty` on the Pi spawn a `tmux` terminal mutliplexer session w/ a `pts` that both my Pi and I can share and because a `tty` spawned it, I can see it live on Pi's hardware display.

Most machines have adequate hardware resources to host an [X server](https://en.wikipedia.org/wiki/X_Window_System) to display a Graphical User Interface (GUI). An X server is software that "provides display and I/O services to applications \[(clients)\]." The Pi's hardware resources become pretty burdened by graphical applications. This is a limitation that is interesting to work around.

### Just Show me the IP - General Purpose Input/Output (GPIO), Pulse-Width Modulation (PWM), & Dutytime
It'd be nice if I could just push a button.\
The Pirate Audio circuit board w/ the LCD sits on 40 General-Purpose Input/Output (GPIO) software controlled digital signal pins I soldered to my Pi.
```
$ pinout
.-------------------------.
| oooooooooooooooooooo J8 |
| 1ooooooooooooooooooo   |c
---+       +---+ PiZero W|s
 sd|       |SoC|   V1.1  |i
---+|hdmi| +---+  usb pwr |
`---|    |--------| |-| |-'

Revision           : 9000c1
SoC                : BCM2835
RAM                : 512MB
Storage            : MicroSD
USB ports          : 1 (of which 0 USB3)
Ethernet ports     : 0 (0Mbps max. speed)
Wi-fi              : True
Bluetooth          : True
Camera ports (CSI) : 1
Display ports (DSI): 0

J8:
   3V3  (1) (2)  5V
 GPIO2  (3) (4)  5V
 GPIO3  (5) (6)  GND
 GPIO4  (7) (8)  GPIO14
   GND  (9) (10) GPIO15
GPIO17 (11) (12) GPIO18
GPIO27 (13) (14) GND
GPIO22 (15) (16) GPIO23
   3V3 (17) (18) GPIO24
GPIO10 (19) (20) GND
 GPIO9 (21) (22) GPIO25
GPIO11 (23) (24) GPIO8
   GND (25) (26) GPIO7
 GPIO0 (27) (28) GPIO1
 GPIO5 (29) (30) GND
 GPIO6 (31) (32) GPIO12
GPIO13 (33) (34) GND
GPIO19 (35) (36) GPIO16
GPIO26 (37) (38) GPIO20
   GND (39) (40) GPIO21
```

For the software to control the pins' digital signals, the Python library [RPi.GPIO](https://pypi.org/project/RPi.GPIO/) can be used.\
Referring to the [Pirate Audio circuit board's lineout](https://pinout.xyz/pinout/pirate_audio_line_out#), software on the Pi can listen for input signal on 4 pins mapped to the 4 buttons on the hat, so that processes can programmatically execute when buttons are pressed. Also, the LCD's backlight is controlled by a [Pulse-Width Moduled (PWM)](https://en.wikipedia.org/wiki/Pulse-width_modulation) digital signal output through pin 13, which software on the Pi can manipulate to change the screen's brightness.\
A nice feature is to have the Pi display its IP addresses on screen at the push of a button, so that I don't have to [nmap](https://nmap.org/book/toc.html) scan a network's whole IP address range to find it, so that I can `ssh` into it from another device.\
Since I have `tty1` spawn a `tmux` session on the display at boot, I want execute the `ip -br addr` command in the `tmux` session on screen so that the output is displayed. So I need to listen for digital signal input on pin 5, which will occur when button `A` is pressed, then run the `ip -br addr` command in the `tmux` session on screen.\
Here's the Python script to do that:

```python
import signal
import os
import RPi.GPIO as GPIO


# The buttons on Pirate Audio are connected to pins 5, 6, 16 and 24
# Boards prior to 23 January 2020 used 5, 6, 16 and 20
# try changing 24 to 20 if your Y button doesn't work.
BUTTONS = [5, 6, 16, 24]

# These correspond to buttons A, B, X and Y respectively
LABELS = ['A', 'B', 'X', 'Y']

# Set up RPi.GPIO with the "BCM" numbering scheme
GPIO.setmode(GPIO.BCM)

# Buttons connect to ground when pressed, so we should set them up
# with a "PULL UP", which weakly pulls the input signal to 3.3V.
GPIO.setup(BUTTONS, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# "handle_button" will be called every time a button is pressed
# It receives one argument: the associated input pin.
def handle_button(pin):
    label = LABELS[BUTTONS.index(pin)]
    if label == 'A':  # write IP addresses to tmux session
        os.system("tmux send 'ip -br addr' ENTER;")

# Loop through out buttons and attach the "handle_button" function to each
# We're watching the "FALLING" edge (transition from 3.3V to Ground) and
# picking a generous bouncetime of 100ms to smooth out button presses.
for pin in BUTTONS:
    GPIO.add_event_detect(pin, GPIO.FALLING, handle_button, bouncetime=100)

# Finally, since button handlers don't require a "while True" loop,
# we pause the script to prevent it exiting immediately.
signal.pause()
```

And I want to have the above Python script already running in the background, so upon boot and auto-login into `tty1`, I lazily have `~/.bashrc` send a [nohup](https://linuxhint.com/how_to_use_nohup_linux/) command to the `tmux` session to run the Python script in the background right away. And because it's `nohup`, it'll keep running even if I accidentally kill the `tmux` session.
```bash
# if logged in as tty1, create and attach to a tmux session
if [[ $(tty) == "/dev/tty1" ]]; then
  tmux new-session -d -s tmuxsesh -c ~
  tmux send 'nohup python /home/john/pirate_audio_buttons.py &>/dev/null &' ENTER
  tmux send ENTER
  tmux send clear ENTER
  tmux a -t tmuxsesh
fi

PS1="$ "
```

When I hit button `A`, I'll see below on the LCD, which briefly shows me the various network interfaces and their IP addresses.
```
$ ip -br addr                 │
lo               UNKNOWN      │
  127.0.0.1/8 ::1/128         │
wlan0            UP           │
  192.168.1.245/24 2600:1700:1│
28:400::3a/128 2600:1700:128:4│
00:c45d:45e3:45e3:5e8a/64 fe80│
::3d70:3094:b97a:2531/64      │
docker0          DOWN         │
  172.17.0.1/16               │
uap0             UP           │
  192.168.27.1/24 169.254.112.│
76/16 fe80::e8cd:a7da:1589:4a9│
f/64                          │
```

If I feel more motivated one day, I'll map a sequence of button presses in [pirate_audio_buttons.py](../pirate_audio_buttons.py) to turn off the LCD backlight via the below Python script & do a soft poweroff of the Pi. Maybe I'll add some logic for button `A` to spawn another `tmux` session and have the Pi change the foreground `tty` to show it on the LCD too if I've accidentally killed `tmux` session or something.
```python
import RPi.GPIO as GPIO


GPIO.setmode(GPIO.BCM)
# we'll have GPIO package deal with BCM (Broadcom GPIO 00..nn numbers)
# rather than BOARD (Raspberry Pi board numbers)
GPIO.setup(13, GPIO.OUT)  # set BCM pin 13 to output a signal
backlight_pin = GPIO.PWM(13, 500)  # set BMC pin 13 to pulse signal waves high(on)/low(off) modulated at 500Hz frequency (500 times a second)
backlight_pin.start(100)  # for each pulse cycle, the signal should be high (on duty) for 100% of the cycle; duty-cycle = 100%
backlight_pin.ChangeDutyCycle(50)  # for each pulse cycle, the signal should be high for 50% of the cycle; duty-cycle = 50%

backlight_pin.stop()
```

### [Linux Frame Buffer](https://www.kernel.org/doc/Documentation/fb/framebuffer.txt)
The above excercise helped me get a bit more familiar with `tty`s and `pts`s and `tmux`, which I could build off in pursuit of the more amusing goal of viewing pictures and watching videos on the 1" LCD.\
Luckily, the LCD display is already set up to impressively, efficiently read pixel data from memory and show it on screen courtesy of [juj/fbcp-ili9341](https://github.com/juj/fbcp-ili9341); I just have to write the right pixel data to memory for it to read and display, ideally at, like, 60hz/fps.\
I need to use the kernel's frame buffer device, which is an API that knows the right physical registers in memory hardware to write color values for each pixel.\

For viewing images utilizing the frame buffer, [fbi-improved](https://www.nongnu.org/fbi-improved/) does the trick.\
For watching videos utilizing the frame buffer, [mplayer](http://www.mplayerhq.hu/design7/documentation.html) does the trick.

For the video demo, I grabbed [BigBuckBunny](https://peach.blender.org/about/) which is licensed under [Creative Commons](https://en.wikipedia.org/wiki/Creative_Commons).
```bash
curl http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4 -O
```

I scaled it down to 240x240 pixels with [ffmpeg](https://en.wikipedia.org/wiki/FFmpeg) to suit the LCD.
```bash
ffmpeg -i BigBuckBunny.mp4 -vf scale=240:240 BigBuckBunny_240x240.mp4
```

Since `mplayer`'s frame buffer video output depends on a proper `teletype` at the foreground of the display, I need to open a new `tty` and send a command along to it to watch the video with `mplayer`.
```bash
sudo openvt -s -l -- mplayer -vo fbdev output.mp4
```

It's a cool trick to be able to remotely display frame buffer video on the Pi's LCD display from an `ssh` `pts`.\
The `mplayer` process can be killed with `kill` & `pgrep`
```bash
sudo kill -9 $(pgrep mplayer)
```

The foreground `tty` can then be switched back to `tty1`'s `tmux` session w/ `chvt`
```bash
sudo chvt 1
```