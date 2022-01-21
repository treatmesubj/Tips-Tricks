# $profile => C:\Users\JohnHupperts\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

echo "===========  ============     ========       ======== `
===========  ===============  =========     ========= `
   =====        ====   =====    ========   ======== `
   =====        ===========     ====  === ===  ==== `
   =====        ===========     ====  =======  ==== `
   =====        ====   =====    ====   =====   ==== `
===========  ===============  ======    ===    ====== `
===========  ============     ======     =     ====== `
"

Set-Alias -Name sublime -Value "C:\Program Files\Sublime Text 3\sublime_text.exe"

function thesr {
   python "C:\Users\JohnHupperts\Documents\Programming_Projects\thesr.py" $args
}

function prompt {
   'PS [' + ($env:UserName) + '] ' + '[' + ($pwd -split '\\')[0] + '] ' + '...\'+$(($pwd -split '\\')[-1] -join '\') + '> '
}
