# Python
```bash
# https://github.com/ktrueda/parquet-tools
pip install parquet-tools

parquet-tools show --columns DELETED,PLACEHOLDER -n 5 coalesced.parquet
# show column names & data-types
parquet-tools inspect file.parquet | awk '/Column\(.*\)|^logical_type/'
```

# Go (Questionable)
```bash
# https://github.com/hangxie/parquet-tools
go install github.com/hangxie/parquet-tools@latest
```

# [DuckDB & DBeaver](https://duckdb.org/docs/guides/sql_editors/dbeaver)
### Quickstart
```sql
FORCE INSTALL httpfs;
LOAD httpfs;
SET s3_access_key_id='';
SET s3_secret_access_key='';
SET s3_endpoint='s3.us.cloud-object-storage.appdomain.cloud';
SET s3_region='s3.us.cloud-object-storage.appdomain.cloud';

SELECT *
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1);
```

### Peristent Secrets
```sql
-- https://duckdb.org/docs/configuration/secrets_manager
-- https://duckdb.org/docs/extensions/httpfs/s3api
-- stored in ~/.duckdb/stored_secrets

CREATE PERSISTENT SECRET bucket-cool1 (
    TYPE S3,
    KEY_ID '',
    SECRET '',
    ENDPOINT 's3.us.cloud-object-storage.appdomain.cloud',
    REGION 's3.us.cloud-object-storage.appdomain.cloud',
    SCOPE 's3://bucket-cool1'
);
SELECT which_secret('s3://bucket-cool1', 's3');

CREATE PERSISTENT SECRET bucket-cool2 (
    TYPE S3,
    KEY_ID '',
    SECRET '',
    ENDPOINT 's3.us.cloud-object-storage.appdomain.cloud',
    REGION 's3.us.cloud-object-storage.appdomain.cloud',
    SCOPE 's3://bucket-cool2'
);
SELECT which_secret('s3://bucket-cool2', 's3');
```

### Querying Parquets
```sql
SELECT *
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1);

DESCRIBE SELECT *
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1);

EXPLAIN ANALYZE SELECT *
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1);
```
