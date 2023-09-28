## [StackExchange Answer](https://askubuntu.com/a/631758)

Insert the original SD card and check the name of the device (usually mmcblkX or sdcX):
```bash
sudo fdisk -l
```
You might see:
```bash
Device         Boot   Start      End  Sectors  Size Id Type
/dev/mmcblk0p1 *       2048  2099199  2097152    1G  c W95 FAT32 (LBA)
/dev/mmcblk0p2      2099200 31116287 29017088 13.9G 83 Linux
```
In my case the SD card is `/dev/mmcblk0` (the `*p1` and `*p2` are the partitions).

Now you have to unmount the device:
```bash
sudo umount /dev/mmcblk0
```
Now to create an image of the device:
```bash
sudo dd if=/dev/mmcblk0 of=~/sd-card-copy.img bs=1M status=progress
```
This will take a while.

Once it's finished, insert the empty SD card. If the device is different (USB or other type of SD card reader) verify its name and be sure to unmount it:
```bash
sudo fdisk -l
sudo umount /dev/mmcblk0
```
Write the image to the device:
```bash
sudo dd if=~/sd-card-copy.img of=/dev/mmcblk0 bs=1M status=progress
```
The write operation is much slower than before.
