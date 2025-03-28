#!/usr/bin/env bash

# good
while read -r line; do
    echo "<$line>"
done < data.txt

while read -r line; do
    echo "<$line>"
done < <(ls -1 ./direcotry)

while read -r line; do
    date -d @$line
done << EOM
1743255907
1743255930
1743256054
1743256316
1743271920
1743272034
1743272063
1743272280
1743272388
1743272482
1743272585
1743272945
EOM

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
