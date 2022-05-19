If you have a keyboard and monitor for your Pi, you can connect to wifi via Bash \
My biggest problem I had to troubleshoot: I realized I had a second copy of `wpa_supplicant.conf`. My `/wpa_supplicant.conf` seemed to maybe be conflicting with my `/etc/wpa_supplicant/wpa_supplicant.conf` so, I deleted the copy from the boot directory. 
1. Check that I already have a wifi enabled network interface:
```bash
iwconfig
wlan0     IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=22 dBm   
          Retry short limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
```
2. Check if `wpa_suplicant` process is running:
```bash
ps -e | grep wpa
388 ?        00:00:00 wpa_supplicant
339 ?        00:00:00 wpa_supplicant
# -John: You might have more than one process running; they're doing different things; all good
```
3. If things aren't working, you can kill `wpa_supplicant`
```bash
sudo pkill wpa_supplicant
```
4. Scan networks to see if your desired wifi network is actually available
`sudo iwlist scan`
5. Edit the configuration file `/etc/wpa_supplicant/wpa_supplicant.conf` with the following contents
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
6. Start a new `wpa_supplicant` process to run off your configuration file
 ```bash
 sudo wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf
 ```
7. To actually get online, you'll have to get an IP somehow. Most people will just want to get a dynamic IP from a DHCP server, probably the one built into the router. To get a DHCP lease, first release whatever leases you're still holding onto (as root):
```bash
sudo dhclient -r
```
8. Then ask for a new lease with your network device (wlan0/eht1):
```bash
sudo dhclient wlan0
```
