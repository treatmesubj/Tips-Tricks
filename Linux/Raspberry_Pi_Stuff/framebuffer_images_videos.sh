# fim is basically fbi with more options
sudo fbi -a -vt 2 /mnt/usb_share/holding_big_gar.jpeg  # view image on tty2, if it exists

sudo openvt -s -l -- fim /mnt/usb_share/john_w_kirk.jpeg # create and switch to tty2 just to view an image
sudo chvt 1  # switch back to tty1
sudo kill -9 $(pgrep fim)  # kill the fim process

# ffmpeg & mplayer to watch videos
ffmpeg -i BigBuckBunny.mp4 -vf scale=240:240 BigBuckBunny_240x240.mp4  # pi 0 w not beefy enough to do this itself. Takes forever
sudo openvt -s -l -- mplayer -vo fbdev output.mp4
sudo kill -9 $(pgrep mplayer)  # kill the mplayer process