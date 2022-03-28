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
### [Linux Dig DNS Lookup](https://linuxize.com/post/how-to-use-dig-command-to-query-dns-in-linux/)

A host name can have multiple ip addresses; ask the DNS what those IP addresses are

```
% dig <ip_addr | Host Name>


```

### OpenSSL
For fetching an SSL certificate

```
% openssl s_client -host <ip_addr> -port <port>


```