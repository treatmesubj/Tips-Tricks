ffmpeg -i terminal.mkv -pix_fmt rgb24 terminal.gif
# trim a 2 pixels off the botttom
ffmpeg -i terminal.mkv -pix_fmt rgb24 -vf crop=in_w:in_h-2:0:0 terminal.gif
