# [How traceroute works](https://networklessons.com/cisco/ccna-routing-switching-icnd1-100-105/traceroute)

You want to send a packet to google.com.
You want to learn each router hop along the way.
You continue to resend your packet incrementing the TTL header by one,
so that you receive a 'TTL exceeded' response from each hop, until you
finally recieve the intended response from google.com

Each router checks its table for the destination, and if it doesn't know it,
queries the next upstream router, its default route, the next hop, and then
your traceroute sends a ping/ICMP to each hop to learn long it takes to receive
a response.
