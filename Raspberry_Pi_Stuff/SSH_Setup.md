# Pi Setup
1. It may be handy to have pi auto-connect to WiFi if it won't be connected to a router via ethernet
	1. On your Micro SD imaged with Raspberry Pi OS, create a new file `/etc/wpa_supplicant/wpa_supplicant.conf` or `/boot/wpa_supplicant.conf` with the below contents. 
		- If you're writing to the Micro SD from Windows, you should see 2 external drives available, which are probably `(D:)` and `(E:)`, one of which will not be a format readable by Windows & the other, will. The readable drive, probably shown as `boot(E:)` or `Removable Disk (E:)` is the `/boot/` directory of the Raspberry Pi.
	```
	ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
	update_config=1
	country=US
	network={
		ssid="your wifi network name"
		psk="wifi password"
		key_mgmt=WPA-PSK
	}
	```
2. Create an empty file `/boot/ssh`
	- alternatively, if the Pi is booted and you have a keyboard, can enable ssh in "raspi-config"
		1. `pi@raspberrypi:~ $ sudo raspi-config`
			1. `> 3. Interface Options`
			2. `> P2 SSH`
			3. `> Yes`
			4. `> Ok`
			5. `> Finish`
```
# default username:password = pi:raspberry`
# w/ sudo, can change password: `sudo passwd pi`
```

3. Finally, ssh in from another device: `PS C:\Users\JohnHupperts> ssh <pi@raspberrypi.local|pi@xx.x.x.xx>`

---
If you've ssh'd into your Pi from a Windows machine before, but forgot the IP address of your Pi, just look at your `C:\Users\<user>\.ssh\known_hosts` file \
If you've ssh'd into some machine from your Debian Linux Raspberry Pi, but for the IP address of that machine, just look at your `/home/<user>/.ssh/known_hosts` file