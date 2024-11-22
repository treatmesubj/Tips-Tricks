```
-bash: /mnt/c/Windows/system32/clip.exe: cannot execute binary file: Exec format error
```

access Windows executables when System D enbaled
https://github.com/microsoft/WSL/issues/8843

```bash
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
sudo systemctl restart systemd-binfmt
```
