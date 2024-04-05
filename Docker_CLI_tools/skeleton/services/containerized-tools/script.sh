#!/usr/bin/env bash
neofetch

if ! test -d /mount-dir; then
    echo "sorry, no /mount-dir"
    echo "try: docker run -it -v ./local-dir/:/mount-dir containerized-tools"
else
    cat /mount-dir/home.txt
fi

secs=$((5 * 60))
while [ $secs -gt 0 ]; do
   echo "$secs"
   sleep 1
   secs=$((secs-=1))
done

# count up
# secs=0
# while true; do
#    echo "$secs"
#    sleep 1
#    secs=$((secs+=1))
# done
