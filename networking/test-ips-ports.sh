#!/usr/bin/env bash

while read -r line; do
    echo $line
    echo $line | xargs -r nc -w 2 -v 
done << EOM
9.209.37.120	50000
9.208.150.211	443
9.209.232.84	22461
EOM
