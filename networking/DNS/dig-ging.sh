# domain to IP
dig thesr.online
host w3.ibm.com 9.0.0.1

# IP to primary host (PTR)
# does not reveal CNAMEs that also resolve to the IP or PTR host
dig -x 140.82.113.4

# ipv4
dig -4 thesr.online
# ipv6
dig -6 thesr.online

# choice dns/nameserver rather than /etc/resolv.conf
dig @8.8.8.8 thesr.online

# search non-FQDM (fully qualified domain name)
dig +search kubernetes
