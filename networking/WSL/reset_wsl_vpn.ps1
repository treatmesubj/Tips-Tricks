Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Where-Object AddressFamily -like "IPv6" | Set-NetIPInterface -InterfaceMetric 45
Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Where-Object AddressFamily -like "IPv4" | Set-NetIPInterface -InterfaceMetric 1

Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Format-Table -AutoSize
