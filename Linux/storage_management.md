# Files

```bash
sizeup() {
    if [ $# -eq 1 ]  # file path arg
    then
        path=$(readlink -m $1)
        if [ -d $path ]  # directory
        then
            du -sh $path/* $path/.[^.]* 2>/dev/null | sort -hr
        else
            du -sh $path | sort -hr
        fi
    else
        du -sh * .[^.]* 2>/dev/null | sort -hr
    fi
}
sizeup
```

---

# Mounted Devices

- `sudo fdisk -l`
```
[snip]
Device         Boot  Start     End Sectors  Size Id Type
/dev/mmcblk0p1        8192  532479  524288  256M  c W95 FAT32 (LBA)
/dev/mmcblk0p2      532480 3923967 3391488  1.6G 83 Linux

```

- `lsblk`
```
[snip]
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
mmcblk0     179:0    0 116.5G  0 disk 
├─mmcblk0p1 179:1    0   256M  0 part
└─mmcblk0p2 179:2    0   1.6G  0 part 

```

- `findmnt`
```
TARGET                          SOURCE        FSTYPE     OPTIONS
/                               /dev/sdc      ext4       rw,relatime,discard,errors=remount-ro,data=ordered
├─/mnt/wsl                      none          tmpfs      rw,relatime
├─/usr/lib/wsl/drivers          none          9p         ro,nosuid,nodev,noatime,dirsync,aname=drivers;fmask=222;dma
├─/usr/lib/wsl/lib              none          overlay    rw,relatime,lowerdir=/gpu_lib_packaged:/gpu_lib_inbox,upper
├─/mnt/wslg                     none          tmpfs      rw,relatime
│ ├─/mnt/wslg/distro            /dev/sdc      ext4       ro,relatime,discard,errors=remount-ro,data=ordered
│ ├─/mnt/wslg/versions.txt      none[/etc/versions.txt]
│ │                                           overlay    rw,relatime,lowerdir=/systemvhd,upperdir=/system/rw/upper,w
│ └─/mnt/wslg/doc               none[/usr/share/doc]
│                                             overlay    rw,relatime,lowerdir=/systemvhd,upperdir=/system/rw/upper,w
├─/init                         rootfs[/init] rootfs     ro,size=4000560k,nr_inodes=1000140
[snip]
```

- `mount -l`
```
none on /mnt/wsl type tmpfs (rw,relatime)
none on /usr/lib/wsl/drivers type 9p (ro,nosuid,nodev,noatime,dirsync,aname=drivers;fmask=222;dmask=222,mmap,access=client,msize=65536,trans=fd,rfd=7,wfd=7)
none on /usr/lib/wsl/lib type overlay (rw,relatime,lowerdir=/gpu_lib_packaged:/gpu_lib_inbox,upperdir=/gpu_lib/rw/upper,workdir=/gpu_lib/rw/work)
/dev/sdc on / type ext4 (rw,relatime,discard,errors=remount-ro,data=ordered)
none on /mnt/wslg type tmpfs (rw,relatime)
[snip]
```

- `sudo df -a -T -h`
```
Filesystem     Type         Size  Used Avail Use% Mounted on
none           tmpfs        3.9G  4.0K  3.9G   1% /mnt/wsl
none           9p           238G  215G   23G  91% /usr/lib/wsl/drivers
none           overlay      3.9G     0  3.9G   0% /usr/lib/wsl/lib
/dev/sdc       ext4        1007G   15G  942G   2% /
none           tmpfs        3.9G  104K  3.9G   1% /mnt/wslg
/dev/sdc       ext4        1007G   15G  942G   2% /mnt/wslg/distro
rootfs         rootfs       3.9G  1.9M  3.9G   1% /init
[snip]
```

## Mounting a storage device to a directory
```
sudo mkdir /media/pi_ssd
sudo mount -t vfat /dev/mmcblk0p1 /media/pi_ssd_boot
lsblk
```

```
[snip]
mmcblk0     179:0    0 116.5G  0 disk 
├─mmcblk0p1 179:1    0   256M  0 part /media/pi_ssd_boot
└─mmcblk0p2 179:2    0   1.6G  0 part 
```

## Unmount a device from directory
```
umount /media/pi_ssd
```
