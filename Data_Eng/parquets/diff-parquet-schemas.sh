#!/usr/bin/env bash
function duckdb() { duckdb.exe "$@"; }

duckdb -csv -noheader -c "
    SELECT DISTINCT filename
    FROM read_parquet('s3://bucket/part-*', hive_partitioning=1, filename=1)
" > ./fileys.txt

# metadata
mkdir -p metadata
while read -r filey; do
    echo fetching metadata for $filey
    duckdb -csv -c "SELECT row_group_num_columns, column_id, path_in_schema, type, compression FROM parquet_metadata('$filey');" < /dev/null \
         > ./metadata/"$(basename "$filey")".csv
done < fileys.txt

baseline=$(ls -1 metadata/ | head -1)

while read -r fili; do
    diff -s ./metadata/"$baseline" ./metadata/"$fili" | grep --color=always -E 'identical|$'
done < <(ls -1 ./metadata)

# schemas
mkdir -p schema
while read -r filey; do
    echo fetching schema for $filey
    duckdb -csv -c "SELECT * EXCLUDE file_name FROM parquet_schema('$filey')" < /dev/null \
         > ./schema/"$(basename "$filey")".csv
done < fileys.txt

baseline=$(ls -1 schema/ | head -1)

while read -r fili; do
    diff -s ./schema/"$baseline" ./schema/"$fili" | grep --color=always -E 'identical|$'
done < <(ls -1 ./schema)
