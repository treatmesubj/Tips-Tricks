## Watching Videos on a 1" Raspberry Pi Zero W LCD Display

<p align="center">
  <img src="../attachments/pi0w_LCD_vid_demo.gif"/> <a href="https://www.youtube.com/watch?v=Z2iemmzBF1A"><img src="../attachments/pi0_youtube_vid2.png"/></a>
</p>

This is my Raspberry Pi Zero W with a Pirate Audio hat on it, which has a ST7789 240x240 LCD display and an audio jack. The display is being driven by the very cool [juj/fbcp-ili9341](https://github.com/juj/fbcp-ili9341). I've got Raspberry Pi OS Lite booting to `/dev/tty1`, which `~/.bashrc` checks, then spawns and attaches to a `tmux` session. I can `ssh` into my Pi's own wifi network spun up via the very cool [cjimti/iotwifi](https://github.com/cjimti/iotwifi) Docker container ([my tweaks](<./wifi_and_WAP.md>)), attach to the session from there too, and display a shared terminal session on the Pi's LCD. The Pi can connect to an actual network, too. \
For more info about how that works, see [my last project](./fbcp-ili9341-SPI-Display-Pirate-Audio.md), which I'm building off for this one.

### [Teletypes, Pseudo-Terminal Slaves, & X Window System](https://unix.stackexchange.com/a/336527)
My Pi has no Desktop Environment Graphical User Interface (GUI). It's got no mouse or keyboard either. It does have a hardware display: the 1" LCD.

On Linux, you've got a few instances of Teletypes (`tty`s). In short, a `tty` is a text input/output environment. A `tty` is a console: a hardware display-screen, hardware keyboard, & software command-line-interface/shell to interact with the kernel (the interface to control the hardware) via issuance of typed out commands which the kernel executes and then writes any relevant output or errors to the display. On 1 computer with 1 kernel, 1 keyboard, & 1 display, you can have multiple `tty`s which you can switch between. On a typical desktop computer which has a Linux distribution installed, one of the `tty`s runs a command to launch a process to spawn the familar GUI desktop environment with your wallpaper, mouse, files, etc, and the actual `tty` command-line-interface/shell under it all is never seen.

A Pseudo-Terminal Slave (`pts`) is like a `tty` but without the physical display & keyboard hardware. I'll be using a `pts` on the Pi from a remote device via the secure shell protocol (`ssh`).\
Also, I'll have a `tty` on the Pi spawn a `tmux` terminal mutliplexer session w/ a `pts` that both my Pi and I can share and because a `tty` spawned it, I can see it live on Pi's hardware display.

Most machines have adequate hardware resources to host an [X server](https://en.wikipedia.org/wiki/X_Window_System) to display a Graphical User Interface (GUI). An X server is software that "provides display and I/O services to applications; applications \[(clients)\] use these services." The Pi's hardware resources become pretty burdened by graphical applications. This is a limitation that is interesting to work around.

### Just Show me the IP - General Purpose Input/Output (GPIO), Pulse-Width Modulation (PWM), & Dutytime
It'd be nice if I could just push a button. 
- [pirate_audio_buttons.py](../pirate_audio_buttons.py)
- [pirate_audio_LCD_backlight.py](../pirate_audio_LCD_backlight.py)

...

### [Linux Framebuffer](https://www.kernel.org/doc/Documentation/fb/framebuffer.txt)
Use the kernel to write color values for each pixel to memory and display it on the LCD, ideally at 60hz/fps. \
Luckily the LCD display itself is already set up, reading pixel data from memory and showing it on the screen, courtesy of [juj/fbcp-ili9341](https://github.com/juj/fbcp-ili9341) \
Now we just have to write the right pixel data to memory and let the display driver know what to display. \
...

### Tying It All Together
...