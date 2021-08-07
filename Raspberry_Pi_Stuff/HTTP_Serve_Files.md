# Navigate to Desired Directory to Serve
```bash
pi@raspberrypi:~ $ cd /home/pi/pictures
```
# Launch Python Server
```bash
pi@raspberrypi:~ $ python3 -m http.server
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```
# HTTP-Get File From Another Device
```PowerShell
PS C:\Users\JohnHupperts> cd ~/Desktop
PS C:\Users\JohnHupperts\Desktop> curl http://10.0.0.50:8000/photo.png -o photo.png
```