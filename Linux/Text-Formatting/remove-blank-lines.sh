#!/usr/bin/env bash
# remove blank lines

sed '/^[[:space:]]*$/d'
sed '/^\s*$/d'
sed '/^$/d'  # favorite
sed -n '/^\s*$/!p'

grep .
grep -v '^$'
grep -v '^\s*$'
grep -v '^[[:space:]]*$'

awk /./
awk 'NF'
awk 'length'
awk '/^[ \t]*$/ {next;} {print}'
awk '!/^[ \t]*$/'

# vim :g/^$/d
