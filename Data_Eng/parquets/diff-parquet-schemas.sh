#!/usr/bin/env bash
function duckdb() { duckdb.exe "$@"; }

duckdb -csv -noheader -c "
    SELECT DISTINCT filename
    FROM read_parquet('s3://bucket/part-*', hive_partitioning=1, filename=1)
" > ./fileys.txt

[[ -s fileys.txt ]] || { echo "Error: No files found" >&2; exit 1; }

echo $(wc -l < fileys.txt) files

echo "
#####################
# fetching metadata #
#####################
"

# fetch metadata
mkdir -p metadata
while read -r filey; do
    echo "$filey"
    base="$(basename $filey)"
    duckdb -csv -c "SELECT row_group_num_columns, column_id, path_in_schema, type, compression FROM parquet_metadata('$filey');" < /dev/null \
         > ./metadata/${base%%.*}.csv
done < fileys.txt

echo "
#####################
# diff'ing metadata #
#####################
"

# compare metadata
baseline=$(find ./metadata/ -type f | head -1)
while read -r fili; do
    diff -us --color=always -L "BASELINE" "$baseline" "$fili" | grep --color=always -E 'identical|$'
done < <(find ./metadata -type f)

echo "
###################
# fetching shemas #
###################
"

# fetch schemas
mkdir -p schema
while read -r filey; do
    echo "$filey"
    base="$(basename $filey)"
    duckdb -csv -c "SELECT * EXCLUDE file_name FROM parquet_schema('$filey')" < /dev/null \
         > ./schema/${base%%.*}.csv
done < fileys.txt

echo "
####################
# diff'ing schemas #
####################
"

# compare schemas
baseline=$(find ./schema/ -type f | head -1)
while read -r fili; do
    diff -us --color=always -L "BASELINE" "$baseline" "$fili" | grep --color=always -E 'identical|$'
done < <(find ./schema -type f)
