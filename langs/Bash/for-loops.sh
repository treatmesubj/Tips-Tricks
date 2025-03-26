#!/usr/bin/env bash

# good
while read -r line; do
    echo "<$line>"
done < data.txt

while read -r line; do
    echo "<$line>"
done < <(ls -1 ./direcotry)

# bad
for token in $(cat data.txt); do
    echo "<$token>"
done

# alternatives
mapfile -t array < data.txt
printf '<%s>\n' "${array[@]}"

coolfunc() {
    line=$1
    echo "(mapfile) called with line: $line"
}
mapfile -t -C coolfunc -c 1 array < data.txt
# print array
printf '<%s>\n' "${array[@]}"
