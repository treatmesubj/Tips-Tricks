# Navigate to Desired Directory to Serve
```bash
pi@raspberrypi:~ $ cd /home/pi/pictures
```
# Launch Python Server
```bash
pi@raspberrypi:~ $ python3 -m http.server
Serving HTTP on x.x.x.x port 8000 (http://x.x.x.x:8000/) ...
```
# HTTP-Get File From Another Device
```PowerShell
PS C:\Users\JohnHupperts> cd ~/Desktop
PS C:\Users\JohnHupperts\Desktop> curl http://xx.x.x.xx:8000/photo.png -o photo.png
```
