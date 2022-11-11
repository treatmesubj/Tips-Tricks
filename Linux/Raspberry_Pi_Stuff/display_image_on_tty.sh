sudo fbi -a -vt 1 /mnt/usb_share/holding_big_gar.jpeg  # view image on tty1
sudo fbi -vt 1 -q  # quit fbi

sudo openvt -c 2 -f -s -- fbi -a /mnt/usb_share/holding_big_gar.jpeg  # create and switch to tty2 just to view an image
# sudo kill - 9 <fbi's pid>  # kill the fbi process