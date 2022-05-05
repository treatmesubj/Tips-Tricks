### Figure Out Your IP Address
* CMD/PowerShell
```
$ipconfig

Wireless LAN adapter Wi-Fi:

   Connection-specific DNS Suffix  . : xxxx
   IPv6 Address. . . . . . . . . . . : xxxx
   IPv6 Address. . . . . . . . . . . : xxxx
   Temporary IPv6 Address. . . . . . : xxxx
   Temporary IPv6 Address. . . . . . : xxxx
   Link-local IPv6 Address . . . . . : xxxx
   IPv4 Address. . . . . . . . . . . : 10.0.0.xxx ***(this device IP)
   Subnet Mask . . . . . . . . . . . : xxxx
   Default Gateway . . . . . . . . . : xxxx
                                       10.0.0.xxx ***(router IP)
```

* Bash
```
$ip route show | grep default

default via 10.0.0.xxx ***(router IP) dev wlan0 proto dhcp src 10.0.0.xxx ***(this device IP) metric 303
10.0.0.xxx/24 ***(net's range of IPs) dev wlan0 proto dhcp scope link src 10.0.0.xxx ***(this device IP) metric 303
```

`ifconfig`