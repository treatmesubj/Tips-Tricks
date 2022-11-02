sudo dhclient -r wlo1  # release
sudo ifconfig  # notice no more inet (IPv4) address under wlo1 anymore
sudo dhclient wlo1  # renew/request
sudo ifconfig  # inet (IPv4) address under wlo1 now