# [SPI-Based LCD Driver](https://github.com/juj/fbcp-ili9341)
My changes for Pimroni PirateAudio 240x240 LCD

1. Edit `/boot/config.txt` to use custom SPI driver
```
hdmi_force_hotplug=1
display_rotate=1
hdmi_group=2
hdmi_mode=87
hdmi_cvt=240 240 60 1 0 0 0
#dtparam=spi=on #disabled for lcd testing
```

2. Clone Repo
```
$ sudo apt-get install cmake
$ cd ~
$ git clone https://github.com/juj/fbcp-ili9341.git
$ cd fbcp-ili9341
```

3. Edit `~/fbcp-ili9341/config.h` and comment out some stuff
```
// Disable ALL_TASKS_SHOULD_DMA
// #ifndef ALL_TASKS_SHOULD_DMA
// #define ALL_TASKS_SHOULD_DMA
// #endif
// If enabled, reads keyboard for input events to detect when the system has gone inactive and backlight
// can be turned off
// #define BACKLIGHT_CONTROL_FROM_KEYBOARD
```

4. Build 
```
$ mkdir build
$ cd build
$ cmake -DPIRATE_AUDIO_ST7789_HAT=ON -DSPI_BUS_CLOCK_DIVISOR=6 -DBACKLIGHT_CONTROL=ON -DSTATISTICS=0 ..
$ make -j
```

5. Run LCD driver process: `$ sudo ./fbcp-ili9341/build/fbcp-ili9341`

## Bonus: Run LCD driver process on boot

6. Edit `/etc/rc.local` & add command for driving LCD on boot
```
sudo /home/john/fbcp-ili9341/build/fbcp-ili9341 >/home/john/lcd_log.txt &
```

## Bonus: RPi OS Lite, Launch TMUX Session & Display on LCD on boot

7. Create Bash script to launch a TMUX session: `$ touch ~/tmux_launch.sh`

8. Add below to `~/tmux_launch.sh`;  [script also here](<./tmux_launch.sh>)
```
#!/bin/bash

tmux new-session -d -s tmuxsesh -c ~
```

9. Have boot terminal attach to the TMUX session; Add below to `~/.bashrc`
```
# if logged in as tty1, attach to tmux session started by /etc/rc.local
if [[ $(tty) == "/dev/tty1" ]]; then
  "echo yep, we're tty1"
  tmux a -t tmuxsesh
fi
```

10. Add `logo.nologo` to end of first line in `/boot/cmdline.txt` to remove Raspberry Pi logo splash from boot

11. ssh to raspberry pi. Attach to the shared session: `$ tmux a -t tmuxsesh`.
12. Check the current tmux sessions: `$ tmux list-clients`
```
/dev/tty1: tmuxsesh [30x30 linux] (utf8)
/dev/pts/1: tmuxsesh [133x30 linux] (utf8)
```
13. You probably want to resize your TMUX terminal to the size of tty1's on the tiny LCD: `<control-b> : resize-window -a`