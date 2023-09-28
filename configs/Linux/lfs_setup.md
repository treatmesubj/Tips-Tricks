# Enter Root
- `su -`

# 7.3.1 Mount devices
- https://www.linuxfromscratch.org/lfs/view/stable/chapter07/kernfs.html

# 7.4 Chroot
- https://www.linuxfromscratch.org/lfs/view/stable/chapter07/chroot.html

# Check if mount worked
- `ls /dev`

# Hop in LFS bash
- `exec /usr/bin/bash --login`
- 10 LFS Bootable
    - worse case, can `diff` the host (Debian) `/boot/config-6.1.0-11-amd64`
      to `/sources/linux-6.1.11/.config`
    - Just enable kernel settings for UEFI: https://www.linuxfromscratch.org/blfs/view/stable/postlfs/grub-setup.html#uefi-kernel

# Debian Host - Utilize its UEFI
- ensure `GRUB_DISABLE_OS_PROBER=false` in `/etc/default/grub`
- `sudo grub-mkconfig -o /boot/grub/grub.cfg`
- `sudo awk -F\' '/menuentry / {print }' /boot/grub/grub.cfg`

# [Post-LFS](https://www.linuxfromscratch.org/lfs/view/stable/chapter11/afterlfs.html)

# Host Machine niceties
- Add below contents to `~/mount_virt.sh`
```bash
#!/bin/bash

function mountbind
{
   if ! mountpoint $LFS/$1 >/dev/null; then
     $SUDO mount --bind /$1 $LFS/$1
     echo $LFS/$1 mounted
   else
     echo $LFS/$1 already mounted
   fi
}

function mounttype
{
   if ! mountpoint $LFS/$1 >/dev/null; then
     $SUDO mount -t $2 $3 $4 $5 $LFS/$1
     echo $LFS/$1 mounted
   else
     echo $LFS/$1 already mounted
   fi
}

if [ $EUID -ne 0 ]; then
  SUDO=sudo
else
  SUDO=""
fi

if [ x$LFS == x ]; then
  echo "LFS not set"
  exit 1
fi

mountbind dev
mounttype dev/pts devpts devpts -o gid=5,mode=620
mounttype proc    proc   proc
mounttype sys     sysfs  sysfs
mounttype run     tmpfs  run
if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
else
  mounttype dev/shm tmpfs tmpfs -o nosuid,nodev
fi 

#mountbind usr/src
#mountbind boot
#mountbind home
```

- Add below contents to `~/.bashrc`
```bash
export LFS=/mnt/lfs
alias lfs='sh ~/mount-virt.sh && sudo /usr/sbin/chroot /mnt/lfs /usr/bin/env -i HOME=/root TERM="$TERM" PS1="\u:\w\\\\$ " PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login'
```

