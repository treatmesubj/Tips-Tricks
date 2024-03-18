# Python
```
# https://github.com/ktrueda/parquet-tools
pip install parquet-tools

parquet-tools show --columns DELETED,PLACEHOLDER -n 5 coalesced.parquet
# show column names & data-types
parquet-tools inspect file.parquet | awk '/Column\(.*\)|^logical_type/'
```

# Go (Questionable)
```
# https://github.com/hangxie/parquet-tools
go install github.com/hangxie/parquet-tools@latest
```

# [DuckDB & DBeaver](https://duckdb.org/docs/guides/sql_editors/dbeaver)
```sql
INSTALL httpfs;
LOAD httpfs;
SET s3_access_key_id='';
SET s3_secret_access_key='';
SET s3_endpoint='s3.us.cloud-object-storage.appdomain.cloud';
SET s3_region='s3.us.cloud-object-storage.appdomain.cloud';
SELECT *
FROM read_parquet('s3://<bucket>/path/*', hive_partitioning=1);

DESCRIBE SELECT *
FROM read_parquet('s3://<bucket>/path/*', hive_partitioning=1);

EXPLAIN ANALYZE SELECT *
FROM read_parquet('s3://<bucket>/path/*', hive_partitioning=1);
```
