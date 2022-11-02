sudo dhclient -r wlo1  # release
sudo ifconfig  # notice no more inet (IPv4) address under wlo1 anymore
sudo dhclient wlo1  # renew/request
sudo ifconfig  # inet (IPv4) address under wlo1 now


less /var/lib/dhcp/dhclient.leases # check your latest IP lease. DHCP, DNS, & Router IP info
#lease {
#  interface "wlo1";
#  fixed-address 192.168.1.65;
#  option subnet-mask 255.255.255.0;
#  option routers 192.168.1.254;
#  option dhcp-lease-time 86400;
#  option dhcp-message-type 5;
#  option domain-name-servers 192.168.1.73;
#  option dhcp-server-identifier 192.168.1.73;
#  option dhcp-renewal-time 43200;
#  option broadcast-address 192.168.1.255;
#  option dhcp-rebinding-time 75600;
#  option host-name "spectre";
#  option domain-name "lan";
#  renew 4 2022/11/03 09:17:23;
#  rebind 4 2022/11/03 18:27:56;
#  expire 4 2022/11/03 21:27:56;
#}

