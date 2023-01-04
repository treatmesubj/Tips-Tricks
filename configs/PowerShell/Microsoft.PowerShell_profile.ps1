# $profile => C:\Users\JohnHupperts\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

function ibm-art {
Write-Host "===========  ============     ========       ======== `
===========  ===============  =========     ========= `
   =====        ====   =====    ========   ========   `
   =====        ===========     ====  === ===  ====   `
   =====        ===========     ====  =======  ====   `
   =====        ====   =====    ====   =====   ====   `
===========  ===============  ======    ===    ====== `
===========  ============     ======     =     ====== `
" -ForegroundColor DarkBlue
}
ibm-art

Set-Alias -Name sublime -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"

function thesr {
   python "C:\Users\JohnHupperts\Documents\Programming_Projects\Thesaurus_Rex\thesr.py" $args
}

function prompt {
   'PS [' + ($env:UserName) + '] ' + '[' + ($pwd -split '\\')[0] + '] ' + '...\'+$(($pwd -split '\\')[-1] -join '\') + '> '
}

# https://github.com/ankitpokhrel/jira-cli
# API token auth: https://jsw.ibm.com/plugins/servlet/de.resolution.apitokenauth/admin
# Installation type: Local
# Jira Server: https://jsw.ibm.com
# config: C:\Users\JohnHupperts/.config/.jira/.config.yml
$env:JIRA_API_TOKEN = "blahblah"
$env:JIRA_AUTH_TYPE = "bearer"

# 'rm' should kindly move stuff to trash. 'which rm' will still point to binary unfortunately
# https://github.com/bdukes/PowerShellModules/blob/main/Recycle/Recycle.psm1
Import-Module "C:\Program Files\WindowsPowerShell\Modules\Recycle\1.5.0\Recycle.psm1"
Set-Alias -Name rm -Value "Remove-ItemSafely" -Option AllScope