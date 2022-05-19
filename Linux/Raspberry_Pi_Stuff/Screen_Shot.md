```bash
pi@raspberrypi:~ $ scrot
```
```
giblib error: Can't open X display. It is running, yeah?
```
```bash
pi@raspberrypi:~ $ export DISPLAY=:0
pi@raspberrypi:~ $ export XAUTHORITY=/home/pi/.Xauthority
pi@raspberrypi:~ $ scrot /home/pi/pictures/<screenshot_name.png> [-d (delay)] [10 (seconds)]
```