Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Set-NetIPInterface -InterfaceMetric 6000

Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*"
Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Format-Table -AutoSize
echo "Cisco Anyconnect VPN's DNS Servers"
(Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-DnsClientServerAddress).ServerAddresses
