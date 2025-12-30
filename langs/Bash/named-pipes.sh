#!/usr/bin/env bash

# named-pipes are FIFO data-streams.
# each byte can only be read exactly once.
# so, if you have multiple readers of a named-pipe,
# OS kernel will load-balance between readers;
# only one reader will receive each output.
# named-pipes do not broadcast each output to all readers.
#
# named-pipes safely used by multiple writers, single reader.

# basic example
# mkfifo ./pipey
# echo hello > ./pipey  # hangs until read
# cat ./pipey

# cat ./pipey # hangs until something to read
# echo hello > ./pipey

# open my named-pipe ./pipey for both reading and writing
# as a random file-descriptor stored in variable 'fd'
exec {fd}<>./pipey
echo "file-descriptor 'fd' is: $fd"

client() {
    local name=$1

    while true; do
        sleep 3
        echo "[client $name] hello" >&"$fd"
    done
}

client foo &  # background job
client bar &  # background job
client baz &  # background job

echo "background jobs are: "
jobs

echo "now reading file-descriptor $fd"
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
