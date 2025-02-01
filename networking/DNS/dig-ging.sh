# domain to IP
dig thesr.online

# IP to domain
dig -x 140.82.113.4

# ipv4
dig -4 thesr.online
# ipv6
dig -6 thesr.online

# choice dns/nameserver rather than /etc/resolv.conf
dig @8.8.8.8 thesr.online

# search non-FQDM (fully qualified domain name)
dig +search kubernetes
