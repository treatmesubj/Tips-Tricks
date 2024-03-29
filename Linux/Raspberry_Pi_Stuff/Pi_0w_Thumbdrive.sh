# adapted from: https://magpi.raspberrypi.com/articles/pi-zero-w-smart-usb-flash-drive


# add to `/boot/config.txt`:
```
dtoverlay=dwc2
```

# add to `/etc/modules`:
```
dwc2
```

sudo reboot

# Create 1Gb USB flashdrive storage & format as FAT32
sudo dd bs=1M if=/dev/zero of=/piusb.bin count=1024  # takes a minute
sudo mkdosfs /piusb.bin -F 32 -I

# mount storage
sudo mkdir /mnt/usb_share
# add to `/etc/fstab`:
```
/piusb.bin /mnt/usb_share vfat users,umask=000 0 2
```
sudo mount -a
lsblk

# add some stuff to that storage
cd /mnt/usb_share

# do some stuff, curl a file

sync

# enable mass storage device mode
sudo modprobe g_mass_storage file=/piusb.bin stall=0 ro=1

# use it as a USB flashdrive

# stop using it as a USB flashdrive
sudo modprobe -r g_mass_storage