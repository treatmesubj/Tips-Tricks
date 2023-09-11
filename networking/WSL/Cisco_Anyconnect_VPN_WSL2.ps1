# connect Cisco Anyconnect VPN to TUNNELALL
# Administrator PowerShell
wsl --shutdown
Get-NetIPInterface | Where-Object ConnectionState -like "Connected"
Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected"
(Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-DnsClientServerAddress).ServerAddresses # to be added to WSL /etc/resolv.conf
# set Cisco VPN interfacemetric greater than WSL's so it is preferred - https://learn.microsoft.com/en-us/windows-server/networking/technologies/network-subsystem/net-sub-interface-metric
Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Set-NetIPInterface -InterfaceMetric 6000
Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected"
# start WSL
# you may need to fix WSL's DNS too
    # $ dig -4 w3.ibm.com # to check if DNS works
    # if not, from PS, PS> ipconfig /all
        # see Ethernet adapter with DNS Suffix ibm.com
            # see DNS Servers
                # add IPv4 DNS Server to WSL's /etc/resolv.conf
                # $ sudo vim etc/resolv.conf


# go back to normal state when done with WSL tunnelall stuff
Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Where-Object AddressFamily -like "IPv6" | Set-NetIPInterface -InterfaceMetric 45
Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Where-Object AddressFamily -like "IPv4" | Set-NetIPInterface -InterfaceMetric 1
