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

`ifconfig`

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

### Map Ports on Device/IP
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

### [Windows Trace Route](https://support.microsoft.com/en-us/topic/how-to-use-tracert-to-troubleshoot-tcp-ip-problems-in-windows-e643d72b-2f4f-cdd6-09a0-fd2989c7ca8e)

```
JohnHupperts> tracert www.google.com

Tracing route to www.google.com [172.217.1.100]
over a maximum of 30 hops:

  1     2 ms    <1 ms    <1 ms  osync.lan [x.x.x.x]
 [snip]
 12    45 ms    48 ms    45 ms  mia09s17-in-f4.1e100.net [172.217.1.100]

Trace complete.
```

### Linux Trace Route

```
pi@raspberrypi:~$ sudo nmap -sn -Pn --traceroute google.com
Starting Nmap 7.70 ( https://nmap.org ) at 2022-02-07 12:02 CST
Nmap scan report for google.com (142.250.191.174)
Host is up (0.041s latency).
Other addresses for google.com (not scanned): 2607:f8b0:4009:81a::200e
rDNS record for 142.250.191.174: ord38s30-in-f14.1e100.net

TRACEROUTE (using proto 1/icmp)
HOP RTT      ADDRESS
1   5.98 ms  osync.lan (x.x.x.x)
[snip]
12  41.06 ms ord38s30-in-f14.1e100.net (142.250.191.174)

Nmap done: 1 IP address (1 host up) scanned in 25.24 seconds
```

### fuzz files against url with gobuster
`gobuster dir -u http://url_goes_here -w /opt/SecLists/Discovery/Web-Content/raft-small-words.txt -x php -o gobust_output`

### [Linux Dig DNS Lookup](https://linuxize.com/post/how-to-use-dig-command-to-query-dns-in-linux/)

A host name can have multiple ip addresses

```
% dig <ip_addr | Host Name>


```

### OpenSSL

```
% openssl s_client -host <ip_addr> -port <port>


```