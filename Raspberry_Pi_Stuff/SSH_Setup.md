# Pi Setup
1. May be handy to have pi auto-connect to wifi
	1. Create new file `/etc/wpa_supplicant/wpa_supplicant.conf` with the following contents
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
2. create an empty file named "ssh" in the boot directory (`/ssh`)
3. If Pi is booted, can enable ssh in "raspi-config"
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

4. Finally, ssh in from another device: `PS C:\Users\JohnHupperts> ssh [pi@raspberrypi.local | pi@10.0.0.50]`
