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
Install Duckdb on Windows with `winget`\
__NOTE__: for DBeaver, Maven's latest driver may not have latest features; you
can grab latest JAR files from
[duckdb/releases](https://github.com/duckdb/duckdb/releases), and in DBeaver
driver settings, add JAR file to `Libraries`, and verify via `Find Class`, that
you've got `Driver class: org.duckdb.DuckDBDriver`
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

### [Peristent Secrets](https://duckdb.org/docs/configuration/secrets_manager.html)
```sql
-- https://duckdb.org/docs/configuration/secrets_manager
-- https://duckdb.org/docs/extensions/httpfs/s3api
-- stored in ~/.duckdb/stored_secrets

CREATE PERSISTENT SECRET staging_buckets (
    TYPE S3,
    KEY_ID '',
    SECRET '',
    ENDPOINT 's3.us.cloud-object-storage.appdomain.cloud',
    REGION 's3.us.cloud-object-storage.appdomain.cloud',
    SCOPE 's3://staging-one',
    SCOPE 's3://staging-two',
    SCOPE 's3://staging-three'
);
SELECT * FROM duckdb_secrets();
SELECT * FROM which_secret('s3://staging-one', 's3');
SELECT * FROM which_secret('s3://staging-two', 's3');
SELECT * FROM which_secret('s3://staging-three', 's3');
```

### Querying Parquets
#### [Investigating Parquet Metadata](https://duckdb.org/docs/stable/data/parquet/metadata.html)
```sql
SELECT *
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1, filename=1);

SELECT *
FROM parquet_metadata('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*');

SUMMARIZE SELECT *  -- null-fields, stats
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1, filename=1);

DESCRIBE SELECT *  -- schema
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1, filename=1);

EXPLAIN ANALYZE SELECT *  -- query plan performance
FROM read_parquet('s3://<bucket>/path/YEAR=*/QUARTER=*/WEEK=*/*', hive_partitioning=1, filename=1);

-- https://duckdb.org/docs/data/partitioning/partitioned_writes.html
COPY (
  SELECT *
  FROM (
    SELECT *, row_number() OVER (PARTITION BY SURROGATE_KEY, REVISION) AS RN
    FROM read_parquet('s3://epm-enterprise-dimensions-staging-2/dimension/DEVELOPMENT_PROJECT_FLAT_DIMENSION/transform.parquet/part-*', hive_partitioning=1) whole
  ) AS marked
  WHERE RN = 1
  -- WHERE RN > 1
  ORDER BY SURROGATE_KEY, REVISION, RN DESC
) TO 's3://epm-hr-staging-2/sandbox/johnh/test.parquet'
(FORMAT PARQUET, OVERWRITE_OR_IGNORE, ROW_GROUP_SIZE 122880, ROW_GROUPS_PER_FILE 2, FILENAME_PATTERN "part-00000-{uuid}.snappy");
-- https://duckdb.org/docs/sql/statements/copy.html#parquet-options
--(FORMAT PARQUET, PARTITION_BY (YEAR, QUARTER, MONTH), OVERWRITE_OR_IGNORE, FILENAME_PATTERN "part-00000-{uuid}.snappy");

```

### DuckDB CLI Execute Statement
```bash
duckdb -markdown < tmp.sql | nvim
duckdb :memory: "SELECT 'hey' yo" -csv
```
