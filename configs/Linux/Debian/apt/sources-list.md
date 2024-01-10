# [Debian SourcesList](https://wiki.debian.org/SourcesList)
- Example: [openjdk-11](https://packages.debian.org/search?keywords=openjdk-11) is no longer supported in Debian 12 Bookworm, but is available via unstable repo

# [Apt-Pinning for Beginners](https://jaqque.sbih.org/kplug/apt-pinning.html)
- `sudo nvim /etc/apt/sources.list`

```
deb http://deb.debian.org/debian bookworm main
deb http://deb.debian.org/debian bookworm-updates main
deb http://security.debian.org/debian-security bookworm-security main
deb http://ftp.debian.org/debian bookworm-backports main

# Unstable
deb http://deb.debian.org/debian unstable main
```

- `sudo nvim /etc/apt/preferences`

```
Package: *
Pin: release a=stable
Pin-Priority: 700

Package: *
Pin: release a=unstable
Pin-Priority: 600

```

- `sudo apt update`
