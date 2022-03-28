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
