# [UV4L Firefox-PC Screen Share to Pi](https://www.linux-projects.org/uv4l/tutorials/screen-mirroring/)
### Installing UV4L Packages on Pi
If UV4L Streaming Server isn't yet installed on Raspberry Pi, install necessary packages:
 ```bash
pi@raspberrypi:~ $ sudo apt-get update
pi@raspberrypi:~ $ sudo apt-install uv4l, uv4l-dummy, uv4l-server, uv4l-webrtc
 ```

### Generate UV4L HTTPS SSL Private Key & Certificate on Pi
If you haven't generated the SSL key & cert on your Pi, generate them:

```bash
pi@raspberrypi:~ $ sudo bash -c "openssl genrsa -out /etc/ssl/private/selfsign.key 2048 && openssl req -new -x509 -key /etc/ssl/private/selfsign.key -out /etc/ssl/private/selfsign.crt -sha256"
```

### Configure Firefox Screen Sharing on PC
Open Firefox on your PC or laptop, type `about:config` in the address bar and press enter. In the Search field, type `media.getusermedia.screensharing.enabled` and toggle its value to true with a double-click. Now search for `media.getusermedia.screensharing.allowed_domains` and add your Raspberry Pi hostname or IP address or domain name to the list in the string (e.g. 192.168.1.2)

### Launch UV4L Instance on Pi
```bash
pi@raspberrypi:~ $ uv4l --driver dummy --auto-video_nr --enable-server \
		--server-option '--use-ssl=yes' \
		--server-option '--ssl-private-key-file=/etc/ssl/private/selfsign.key' \
		--server-option '--ssl-certificate-file=/etc/ssl/private/selfsign.crt' \
		--server-option '--enable-webrtc-video=no' \
		--server-option '--enable-webrtc-audio=no' \
		--server-option '--webrtc-receive-video=yes' \
		--server-option '--webrtc-receive-audio=yes' \
		--server-option '--webrtc-renderer-source-size=yes' \
		--server-option '--webrtc-renderer-fullscreen=yes' \
		--server-option '--webrtc-receive-datachannels=no' \
		--server-option '--port=9000'
```

### Visit Pi Streaming Server and Share Screen
On your PC in Firefox, visit `https://raspberrypi:9000/stream/webrtc` where `raspberrypi` is host-name or IP of your Pi \
Under `Cast local Audio/Video sources to remote peer`, choose appropriate settings. Then, click the green `Call!` button to begin sharing \
![](attachments/stream_web_interface.png)
