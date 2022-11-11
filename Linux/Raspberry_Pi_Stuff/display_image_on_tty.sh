# fim is basically fib with more options
sudo fbi -a -vt 2 /mnt/usb_share/holding_big_gar.jpeg  # view image on tty2, if it exists

sudo openvt -s -l -- fim /mnt/usb_share/john_w_kirk.jpeg # create and switch to tty2 just to view an image
sudo chvt 1  # switch back to tty1
sudo kill - 9 $(pgrep fim)  # kill the fbi process