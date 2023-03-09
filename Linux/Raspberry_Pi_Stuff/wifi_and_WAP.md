# Wireless Router Wifi Client & Wireless Access Point (WAP)... to Another Router \[Connected to the Internet\]; Adapted From [cjimti/iotwifi](https://github.com/cjimti/iotwifi) but setup from SSH
## Wireless Router Wifi Client
So that you can configure your Pi's connection to a wifi network over its own wifi network, probably using SSH
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
	       "wpa_passphrase":"raspberry",
	       "channel": "6"
	    },
	      "wpa_supplicant_cfg": {
	        "cfg_file": "/etc/wpa_supplicant/wpa_supplicant.conf"
	    }
	}
	```
8. Add command to `/etc/rc.local` to run start docker image at boot `docker run --rm --privileged --net host -v wificfg.json:/cfg/wificfg.json cjimti/iotwifi --restart:unless-stopped &`
9. Disable `wpa_supplicant` - your `ssh` session will be disconnected
	```bash
	sudo systemctl mask wpa_supplicant.service
	sudo mv /sbin/wpa_supplicant /sbin/no_wpa_supplicant
	sudo pkill wpa_supplicant
	```
10. Exit the hung `ssh` session in your terminal: `[Enter] ~.`
11. Reboot Raspberry Pi

## Wireless Access Point (WAP)... to Another Router \[Connected to the Internet\]
1. Scan wifi networks: `$ curl http://<raspberry_pi_ip>:8080/scan`
2. Connect to wifi network:
	```bash
	$ curl -d '{"ssid":"home-network", "psk":"mystrongpassword"}' \
	     -H "Content-Type: application/json" \
	     -X POST <raspberry_pi_ip>:8080/connect
	```
3. Check wifi status: `$ curl http://raspberry_pi_ip:8080/status`
4. Kill the wifi connection: `$ curl http://raspberry_pi_ip:8080/kill`
