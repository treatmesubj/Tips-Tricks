#!/usr/bin/env bash
# set -xe

# find the deviant parquet file

# SELECT DISTINCT filename
# FROM read_parquet('s3://epm-enterprise-dimensions-black-2/dimension/EMPLOYEE_DIMENSION/transform.parquet/part-*', hive_partitioning=1, filename=1)

mkdir out
while read -r filey; do
    echo $filey
    duckdb.exe :memory: "SELECT row_group_num_columns, column_id, path_in_schema, type, compression FROM parquet_metadata('s3://epm-enterprise-dimensions-black-2/dimension/EMPLOYEE_DIMENSION/transform.parquet/$filey');" -csv < /dev/null > out/$filey.csv
    echo 'next'
done < emp-dim-files.txt

while read -r fili; do
    diff -q ./out/"$fili" ./out/part-00000-037ac924-0442-4092-a738-c46aed0cd867-c000-attempt_202409051011032546939859126934129_0299_m_000000_9712.snappy.parquet.csv
done < <(ls -1 ./out)

# SELECT *
# FROM parquet_metadata('s3://epm-enterprise-dimensions-black-2/dimension/EMPLOYEE_DIMENSION/transform.parquet/part-00000-99.snappy.parquet')
