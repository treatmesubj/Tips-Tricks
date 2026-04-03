#!/usr/bin/env bash
function duckdb() { duckdb.exe "$@"; }

duckdb -csv -noheader -c "
    SELECT DISTINCT filename
    FROM read_parquet('s3://epm-finance-black-2/fact/FBI/BUDGET_RCE_FACT/transform.parquet/2026/COREHW/planning_case_key=*/part-*', hive_partitioning=1, filename=1)
" > ./fileys.txt

mkdir -p out
while read -r filey; do
    echo $filey
    duckdb -csv -c "SELECT row_group_num_columns, column_id, path_in_schema, type, compression FROM parquet_metadata('$filey');" < /dev/null \
         > ./out/"$(basename "$filey")".csv
done < fileys.txt

baseline=$(ls -1 out/ | head -1)

while read -r fili; do
    diff -s ./out/"$baseline" ./out/"$fili"
done < <(ls -1 ./out)
