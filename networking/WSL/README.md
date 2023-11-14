1. Make Windows prefer the VPN interface for traffic, above all else
    - See [Cisco\_Anyconnect\_VPN\_WSL2.ps1](./Cisco_Anyconnect_VPN_WSL2.ps1)
    - For more convenient `wsl_vpn` & `reset_wsl_vpn` functions/commands, see my [PS Profile/Config](https://github.com/treatmesubj/Tips-Tricks/blob/master/configs/PowerShell/Microsoft.PowerShell_profile.ps1)
        - maybe add an alias to `~/.bashrc` for `powershell.exe wsl_vpn`
2. Configure `dnsmasq` to utilize the VPN's DNServer for VPN/intranet domains and Google's DNServer for other/internet
    - See [WSL\_VPN\_DNS.md](./WSL_VPN_DNS.md)

---
**NOTE**: also see [wsl-config docs](https://github.com/MicrosoftDocs/WSL/blob/main/WSL/wsl-config.md)
