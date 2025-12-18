#!/usr/bin/env bash

# indexed arrays
declare -a array=(foo bar baz)
echo "${array[@]}"
echo "${array[-1]}"

declare -a newarray=("${array[@]}" bang bop)
echo "${newarray[@]}"

newarray+=(funk flip)
echo "${newarray[@]}"

declare -p newarray

declare -a newarray=([0]="foo" [1]="bar" [2]="baz" [3]="bang" [4]="bop" [5]="funk" [6]="flip" [99]="wow")
echo "${newarray[99]}"

echo "len: ${#newarray[@]}"

# associative arrays (dictionaries)
declare -A anotherarray
anotherarray[foo]=1
anotherarray[bar]=2
anotherarray[baz]=3

declare -p anotherarray
echo "${anotherarray[bar]}"

# keys
for key in "${!anotherarray[@]}"; do
    echo "key: $key"
    echo "value: ${anotherarray[$key]}"
done

# values
for value in "${anotherarray[@]}"; do
    echo "value: $value"
done
