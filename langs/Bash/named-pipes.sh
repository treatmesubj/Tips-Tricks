#!/usr/bin/env bash

# mkfifo ./pipey
exec {fd}<>pipey

client() {
    local name=$1

    while true; do
        sleep 3
        echo "[client $name] hello" >&$fd
    done
}

client foo &
client bar &
client baz &

while read -r -u "$fd" line; do
    echo "[read line] $line"
done

# $ ps -f
#     PID TTY      STAT   TIME COMMAND
#   20198 pts/3    Ss     0:00 -bash
#   20256 pts/3    S+     0:00  \_ bash ./named-pipes.sh
#   20257 pts/3    S+     0:00      \_ bash ./named-pipes.sh
#   20372 pts/3    S+     0:00      |   \_ sleep 3
#   20258 pts/3    S+     0:00      \_ bash ./named-pipes.sh
#   20370 pts/3    S+     0:00      |   \_ sleep 3
#   20260 pts/3    S+     0:00      \_ bash ./named-pipes.sh
#   20371 pts/3    S+     0:00          \_ sleep 3

