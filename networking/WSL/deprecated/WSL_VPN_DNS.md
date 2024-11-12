This assumes you're using SystemD

1. Disable WSL automatic `/etc/resolv.conf`
    - WSL stupidly puts the IP assigned to Windows' virtual ethernet interface for WSL, yet WSL has no idea what that is
    - Add below to `/etc/wsl.conf`
        ```
        [network]
        generateResolvConf=false
        [boot]
        systemd=true
        ```
    - `PS> wsl --shutdown`
2. Temporarily, we need Google's DNS to find things on the internet. Add below to `/etc/resolv.conf`
    ```
    nameserver   8.8.8.8
    ```
3. Install `dnsmasq`
    - `sudo apt install dnsmasq`
4. Configure `dnsmasq` by setting/appending contents of/to `/etc/dnsmasq.conf` to below.
    ```
    no-resolv  # if DNS server doesn't respond, don't try next nameserver in /etc/resolv.conf
    no-poll  # if DNS server doesn't respond, don't try next nameserver in /etc/resolv.conf
    server=/ibm.com/9.0.0.1
    server=/ibm.com/2620:1f7::1
    rev-server=9.0.0.1/18,9.0.0.1
    server=8.8.8.8  # default DNS is Google
    server=2001:4860:4860::8888  # default DNS is Google
    ```
5. We want DNS to be directed to our own `dnsmasq` server. Set contents of `/etc/resolv.conf` to below.
    ```
    nameserver   127.0.0.1
    ```
6. Start `dnsmasq`
    - `sudo systemctl restart dnsmasq`

**NOTE**: `ping`s and `traceroute`s to internet when on `TUNNELALL` VPN may not work, but normal TCP/IP traffic should find its way back to you

