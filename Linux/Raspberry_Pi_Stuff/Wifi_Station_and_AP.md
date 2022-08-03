# Wifi Station & AP; [Adapted From](https://imti.co/iot-wifi/)but for setup via SSH over Wifi
1. `$ curl -sSL https://get.docker.com | sh`
2.  `$ sudo usermod -aG docker john`
3. `$ sudo reboot`
4. Test Docker: `$ docker run --rm hello-world`
5. `$ docker pull cjimti/iotwifi`
6. `$ wget https://raw.githubusercontent.com/cjimti/iotwifi/master/cfg/wificfg.json`
7. `$ sudo nano wificfg.json`
	```json
	{
	    "dnsmasq_cfg": {
	      "address": "/#/192.168.27.1",
	      "dhcp_range": "192.168.27.100,192.168.27.150,1h",
	      "vendor_class": "set:device,IoT"
	    },
	    "host_apd_cfg": {
	       "ip": "192.168.27.1",
	       "ssid": "johnpiwifi",
	       "wpa_passphrase":"<password>",
	       "channel": "6"
	    },
	      "wpa_supplicant_cfg": {
	        "cfg_file": "/etc/wpa_supplicant/wpa_supplicant.conf"
	    }
	}
	```
8. Add command to `/etc/rc.local` to run start docker image at boot`docker run --rm --privileged --net host -v wificfg.json:/cfg/wificfg.json cjimti/iotwifi --restart:unless-stopped &`
9. Disable `wpa_supplicant` - your `ssh` session will be disconnected
	```bash
	sudo systemctl mask wpa_supplicant.service
	sudo mv /sbin/wpa_supplicant /sbin/no_wpa_supplicant
	sudo pkill wpa_supplicant
	```
10. Exit the hung `ssh` session in your terminal: `[Enter] ~.`
11. Reboot Raspberry Pi