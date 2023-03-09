# Pi Setup
You should've already imaged your Micro SD with Raspberry Pi OS \
It may be handy to have pi auto-connect to WiFi if it won't be connected to a router via Ethernet \
To do so, you'll need to create 2 files in the _boot partition_ of the Raspberry Pi's Micro SD, which will be the `/boot/` directory in Raspberry Pi OS
- If you're writing to the Micro SD from Windows, you should see 2 external drives available, which are probably `(D:)` and `(E:)`, one of which will not be a format readable by Windows & the other, will. The readable drive, probably shown as `boot(E:)` or `Removable Disk (E:)` is the `/boot/` directory of the Raspberry Pi.
- If you're writing to the Micros SD from Linux, you'll need to mount the _boot partition_ as a directory on your host machine's file system and create the files in that directory. For help, see my [Bash Storage Management notes](<../Bash/storage_management.md>)

If you haven't set up a default user on a fresh install of Raspbian OS, follow below.
1. Encrpyt a password and copy it to your clipboard: `$ echo 'mypassword' | openssl passwd -6 -stdin | xclip -select clipboard`
2. In boot partition of Micro SD, `$ sudo touch userconf.txt`
3. In boot partition of Micro SD, add `<username>:<encrypted-password>` to `userconf.txt`


## 1. Create `/boot/wpa_supplicant.conf`
Within `wpa_supplicant.conf`, add the below contents
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
## 2. Create an empty file `/boot/ssh`
- alternatively, if the Pi is booted and you have a keyboard, can enable ssh in "raspi-config"
	1. `pi@raspberrypi:~ $ sudo raspi-config`
		1. `> 3. Interface Options`
		2. `> P2 SSH`
		3. `> Yes`
		4. `> Ok`
		5. `> Finish`

## Extra Notes
```
# default username:password = pi:raspberry`
# w/ sudo, can change password: `sudo passwd pi`
```

- Finally, ssh in from another device: `$ ssh <pi@raspberrypi.local | pi@xx.x.x.xx>`
- Set the terminal type: `$ export TERM="xterm-256color"`

---
If you've ssh'd into your Pi from a Windows machine before, but forgot the IP address of your Pi, just look at your `C:\Users\<user>\.ssh\known_hosts` file \
If you've ssh'd into some machine from your Debian Linux Raspberry Pi, but for the IP address of that machine, just look at your `/home/<user>/.ssh/known_hosts` file \
Your Raspberry Pi's host key might change over time. You'll be warned by SSH that it has. Just remove its entry from your `~/.ssh/known_hosts` file\
[SSH Shenanigans](https://blog.0xffff.info/2021/07/25/ssh-shenanigans-part-1-tips-tricks/)
