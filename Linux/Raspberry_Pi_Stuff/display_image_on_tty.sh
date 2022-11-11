sudo fbi -a -vt 2 /mnt/usb_share/holding_big_gar.jpeg  # view image on tty2, if it exists
sudo fbi -vt 2 -q  # quit fbi

sudo openvt -c 2 -f -s -- fbi -a /mnt/usb_share/holding_big_gar.jpeg  # create and switch to tty2 just to view an image
sudo chvt 1  # switch back to tty1
# sudo kill - 9 <fbi's pid>  # kill the fbi process