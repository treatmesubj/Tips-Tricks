# looking around

`sudo fdisk -l`

```
[snip]
Device         Boot  Start     End Sectors  Size Id Type
/dev/mmcblk0p1        8192  532479  524288  256M  c W95 FAT32 (LBA)
/dev/mmcblk0p2      532480 3923967 3391488  1.6G 83 Linux

```

`lsblk`

```
[snip]
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
mmcblk0     179:0    0 116.5G  0 disk 
├─mmcblk0p1 179:1    0   256M  0 part
└─mmcblk0p2 179:2    0   1.6G  0 part 

```

# mounting a storage device to a directory
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

# unmount a device from directory
```
umount /media/pi_ssd
```