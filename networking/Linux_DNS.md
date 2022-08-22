1. from PowerShell
```
> ipconfig /all
...
Ethernet adapter Ethernet 2:

   Connection-specific DNS Suffix  . : xxx.com
   Description . . . . . . . . . . . : xxx
   Physical Address. . . . . . . . . : 00-00-00-00-00-00
   DHCP Enabled. . . . . . . . . . . : No
   Autoconfiguration Enabled . . . . : Yes
   Link-local IPv6 Address . . . . . : fe80::fe80:fe8:fe80:fe80%fe(Preferred)
   IPv4 Address. . . . . . . . . . . : 9.111.11.111(Preferred)
   Subnet Mask . . . . . . . . . . . : 255.255.224.0
   Default Gateway . . . . . . . . . :
   DHCPv6 IAID . . . . . . . . . . . : 222222222
   DHCPv6 Client DUID. . . . . . . . : 00-00-00-00-00-00-00-00-00-00-00-00-00-00
   DNS Servers . . . . . . . . . . . : 2.0.0.1
                                       2.0.0.2
   NetBIOS over Tcpip. . . . . . . . : Enabled
...
```
- Note the DNS Server `2.0.0.1`

2. from WSL Ubuntu Bash
```
$ sudo nano /etc/resolv.conf # insert at top of list: nameserver 2.0.0.1
```
 - if you add below to `/etc/wsl.conf`, you need to exit WSL and run `wsl --shutdown` from PowerShell for it to actually take effect next time you boot WSL
 ```
[network]
generateResolvConf=false
 ```