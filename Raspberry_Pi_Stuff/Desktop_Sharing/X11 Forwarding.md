## Server Side Linux
1. In `/etc/ssh/sshd_config` ensure `X11Forwarding yes`

## Host Side Windows
1. Download and install [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
2. Download and install [Xming X Server for Windows](https://sourceforge.net/projects/xming/)
3. Run `C:\Program Files (x86)\Xming\XLaunch.exe` and step through
4. Launch `C:\Program Files\PuTTY\putty.exe`
	1. `Host Name/IP & Port`
	2. `Connection type: ssh`
	3. `Connection [+] -> SSH [+] -> X11 -> [v]Enable X11 Forwarding`

## Host Side Linux
1. `ssh -X <ip>`

---
## Troubleshooting
1. `export`
	1. check `DISPLAY=:<display>`
2. If necessary, `export DISPLAY=:<display>`

## Firefox from Server to Host
1. Kill any Firefox instances
2.  `firefox -no-remote`