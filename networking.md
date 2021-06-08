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
$ip route show

default via 10.0.0.xxx ***(router IP) dev wlan0 proto dhcp src 10.0.0.xxx ***(this device IP) metric 303
10.0.0.xxx/24 ***(net's range of IPs) dev wlan0 proto dhcp scope link src 10.0.0.xxx ***(this device IP) metric 303
```

### Find Devices on Network
```
$sudo nmap -sn 10.0.0.xxx/24

Starting Nmap 7.70 ( https://nmap.org ) at 2021-05-06 11:21 CDT
Nmap scan report for 10.0.0.xxx
Host is up (0.0031s latency).
MAC Address: xxx (Arris Group)
Nmap scan report for 10.0.0.xxx
Host is up (0.20s latency).
MAC Address: xxx (Nest Labs)
Nmap scan report for 10.0.0.xxx
Host is up (0.21s latency).
MAC Address: xxx (Nest Labs)
Nmap scan report for 10.0.0.xxx
Host is up (0.21s latency).
MAC Address: xxx (Hewlett Packard)
[snip]
Host is up.
Nmap done: 256 IP addresses (17 hosts up) scanned in 9.95 seconds
```

### Map Ports on Device
```
$mkdir nmap
$sudo nmap -sC -sV -oA [nmap/scan_res] [ip_addr] -v

[snip]
Discovered open port 135/tcp on 10.0.0.xxx
Discovered open port 445/tcp on 10.0.0.xxx
Discovered open port 139/tcp on 10.0.0.xxx
Discovered open port 5357/tcp on 10.0.0.xxx
[snip]

$cat /nmap/scan_res.nmap

# Nmap 7.70 scan initiated Thu May  6 11:29:29 2021 as: nmap -sC -sV -oA nmap/scan_res -v 10.0.0.xxx
Nmap scan report for 10.0.0.xxx
Host is up (0.012s latency).
Not shown: 996 filtered ports
PORT     STATE SERVICE       VERSION
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp  open  microsoft-ds?
5357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
[snip]
```
### fuzz files against url with gobuster
`gobuster dir -u http://url_goes_here -w /opt/SecLists/Discovery/Web-Content/raft-small-words.txt -x php -o gobust_output`
