#!/usr/bin/env bash

# good
while read -r line; do
    echo "<$line>"
done < data.txt

while read -r line; do
    echo "<$line>"
done < <(ls -1 ./direcotry)

# C-style
max=4
for ((i = 1; i <= max; i++)); do
    echo "$i"
done

while read -r line; do
    date -d @$line
done << EOM
1743255907
1743255930
1743256054
EOM

# bad
for token in $(cat data.txt); do
    echo "<$token>"
done

################
# alternatives #
################

# mapfile: read stdin newlines into array
mapfile -t myarray < data.txt
declare -p myarray
printf '<%s>\n' "${myarray[@]}"
#
coolfunc() {
    line=$1
    echo "(mapfile) called with line: $line"
}
mapfile -t -C coolfunc -c 1 myarray < data.txt
declare -p myarray
printf '<%s>\n' "${myarray[@]}"
#
mapfile -t myarray < <(ls -1)
declare -p myarray
printf '<%s>\n' "${myarray[@]}"

# collect IFS-separated-stdout into array
# default IFS is space/tab/newline
myarray=( $(ls -1) )
declare -p myarray
printf '<%s>\n' "${myarray[@]}"
#
IFS=$'?'; myarray=( $(ls -1) ); unset IFS
declare -p myarray
printf '<%s>\n' "${myarray[@]}"

