#!/usr/bin/env bash

# netcat
while read -r line; do
    echo $line
    echo $line | xargs -r nc -v -w 2
done << EOM
9.209.37.120	50000
9.208.150.211	443
9.209.232.84	22461
EOM

# check if IP is reachable & port open
nc -z -v -w 5 9.208.80.227 443
