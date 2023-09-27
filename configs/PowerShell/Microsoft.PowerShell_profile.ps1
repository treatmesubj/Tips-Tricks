# $profile => ~\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

function ibm-art {
Write-Host "===========  ============     ========       ======== `
===========  ===============  =========     ========= `
   =====        ====   =====    ========   ========   `
   =====        ===========     ==== ==== ==== ====   `
   =====        ===========     ====  =======  ====   `
   =====        ====   =====    ====   =====   ====   `
===========  ===============  ======    ===    ====== `
===========  ============     ======     =     ====== `
" -ForegroundColor DarkBlue
}
# ibm-art

Set-Alias -Name sublime -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"
Set-Alias -Name firefox -Value "C:\Program Files\Mozilla Firefox\firefox.exe"

function list {
    wsl ls -a -h -s -1 --color $args
}

function thesr {
    python -m thesr.thesr $args
}

function prompt {
    write-host (($env:UserName) + '@' + ($env:ComputerName) + ':' + (($pwd) -replace "C:\\Users\\JohnHupperts","~")) -ForegroundColor White
    write-host 'PS>' -NoNewline -BackgroundColor DarkBlue -ForegroundColor White
    return " "
}

Set-PSReadlineKeyHandler -Key 'ctrl+l' -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearScreen()
    [Microsoft.PowerShell.PSConsoleReadLine]::CancelLine()
    $(Clear-Host)
}

function wsl_vpn {
    Start-Process -FilePath powershell.exe -ArgumentList { ~/wsl_vpn.ps1 } -Wait -verb RunAs # Admin
    # ~/wsl_vpn.ps1:
        # Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Set-NetIPInterface -InterfaceMetric 6000
    Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*"
    Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Format-Table -AutoSize
    echo "Cisco Anyconnect VPN's DNS Servers"
    (Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-DnsClientServerAddress).ServerAddresses

}

function reset_wsl_vpn {
    Start-Process -FilePath powershell.exe -ArgumentList { ~/reset_wsl_vpn.ps1 } -Wait -verb RunAs # Admin
    # ~/reset_wsl_vpn.ps1:
        # Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Where-Object AddressFamily -like "IPv6" | Set-NetIPInterface -InterfaceMetric 45
        # Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Where-Object AddressFamily -like "IPv4" | Set-NetIPInterface -InterfaceMetric 1
    Get-NetAdapter | Where-Object InterfaceDescription -like "Cisco AnyConnect*" | Get-NetIPInterface | Where-Object ConnectionState -like "Connected" | Format-Table -AutoSize
}

# 'rm' should kindly move stuff to trash. 'which rm' will still point to binary unfortunately
# https://github.com/bdukes/PowerShellModules/blob/main/Recycle/Recycle.psm1
Import-Module "C:\Program Files\WindowsPowerShell\Modules\Recycle\1.5.0\Recycle.psm1"
Set-Alias -Name rm -Value "Remove-ItemSafely" -Option AllScope
