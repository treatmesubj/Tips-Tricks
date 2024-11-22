1. Make Windows prefer the VPN interface for traffic, above all else
    - See [Cisco\_Anyconnect\_VPN\_WSL2.ps1](./Cisco_Anyconnect_VPN_WSL2.ps1)
    - For more convenient `wsl_vpn` & `reset_wsl_vpn` functions/commands, see my [PS Profile/Config](https://github.com/treatmesubj/Tips-Tricks/blob/master/configs/PowerShell/Microsoft.PowerShell_profile.ps1)
        - maybe add an alias to `~/.bashrc` for `powershell.exe wsl_vpn`
            - also see [WSL_SysD_Access_exes.md](../../configs/Linux/WSL/WSL_SysD_Access_exes.md)
2. ~~Configure `dnsmasq` to utilize the VPN's DNServer for VPN/intranet domains and Google's DNServer for other/internet~~
    - ~~See [WSL\_VPN\_DNS.md](./deprecated/WSL_VPN_DNS.md)~~

**NOTE**: also see [wsl-config docs](https://github.com/MicrosoftDocs/WSL/blob/main/WSL/wsl-config.md)

## Troubleshooting
- `dig ibm.com`, `dig google.com`
- `pshell reset_wsl_vpn`
- `pshell wsl_vpn`
1. disconnect/reconnect to VPN
2. ~~restart `dnsmasq`: `sudo sytemctl restart dnsmasq && sudo systemctl status dnsmasq`~~
3. ~~verify `/etc/dnsmasq.conf` is as expected~~
4. verify `/etc/wsl.conf` is as expected
5. verify `/etc/resolv.conf` is as expected
    ```
    nameserver 10.255.255.254
    search ibm.com lotus.com s81c.com ibmmodules.com ibmuc.com lan
    ```
6. ~~try Google's DNS w/o `dnsmasq`: `sudo echo nameserver 8.8.8.8 > /etc/resolv.conf && dig google.com`~~
    - ~~return to use of `dnsmasq` DNS: `sudo echo nameserver 127.0.0.1 > /etc/resolv.conf && dig google.com`~~
7. disconnect/reconnect to VPN
- `pshell reset_wsl_vpn`
- `pshell wsl_vpn`
- potentially restart wsl: `PS> wsl --shutdown`
