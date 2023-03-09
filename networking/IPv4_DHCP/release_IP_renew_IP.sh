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

dhcpcd --dumplease /var/lib/dhcpcd/eth0.leases
# broadcast_address='192.168.1.255'
# dhcp_lease_time='86400'
# dhcp_message_type='5'
# dhcp_rebinding_time='75600'
# dhcp_renewal_time='43200'
# dhcp_server_identifier='192.168.1.254'
# domain_name='attlocal.net'
# domain_name_servers='192.168.1.254'
# ip_address='192.168.1.73'
# network_number='192.168.1.0'
# routers='192.168.1.254'
# subnet_cidr='24'
# subnet_mask='255.255.255.0'
# time_offset='4294949296'
# vivso_enterprise_number='3561'
# dhcp6_client_id='000100012abe8daadca632f78aca'
# dhcp6_domain_search='attlocal.net'
# dhcp6_ia_na1_ia_addr1='2600:1700:128:400::27'
# dhcp6_ia_na1_ia_addr1_pltime='3600'
# dhcp6_ia_na1_ia_addr1_vltime='3600'
# dhcp6_ia_na1_iaid='32f78aca'
# dhcp6_ia_na1_t1='1800'
# dhcp6_ia_na1_t2='2880'
# dhcp6_name_servers='2600:1700:128:400::1'
# dhcp6_preference='255'
# dhcp6_reconfigure_accept=''
# dhcp6_server_id='000100012af1ee1e5860d87bacf0'
