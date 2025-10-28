#!/usr/bin/env python3
import duckdb
import pandas as pd
import getpass


def round_power_of_2(n: int):
    if n > 1:
        n = n - 1
    while n & n - 1:
        n = n & n - 1
    return n << 1


with duckdb.connect() as con:
    con.execute(f"SET s3_access_key_id='{input('s3_access_key_id: ')}';")
    con.execute(
        f"SET s3_secret_access_key='{getpass.getpass(prompt='s3_secret_access_key: ')}';"
    )
    con.execute("SET s3_endpoint='s3.us.cloud-object-storage.appdomain.cloud';")
    con.execute("SET s3_region='s3.us.cloud-object-storage.appdomain.cloud';")
    query = """
SELECT *
FROM read_parquet('s3://epm-enterprise-dimensions-staging-2/dimension/JOB_ROLE_DIMENSION_75537/transform.parquet/part-*', hive_partitioning=1)
"""
    print(query)
    df = con.execute(query).fetchdf()
    print(df.head())

    for col in df:
        print(col, "->", df[col].astype(str).str.len().max())

    print("#" * 50)

    # print approximate DDL
    print("CREATE TABLE SCHEMA.TABLE(")
    for col in df.columns:
        col_name = col.upper().replace("-", "_").replace(" ", "_")
        length = round_power_of_2(df[col].astype(str).str.len().max())
        if col == df.columns[-1]:
            comma = ""
        else:
            comma = ","

        dtype_map = {
            "object": f"VARCHAR({length})",
            "string": f"VARCHAR({length})",
            "int8": "INTEGER",
            "int16": "INTEGER",
            "int32": "INTEGER",
            "int64": "INTEGER",
            "uint8": "INTEGER",
            "uint16": "INTEGER",
            "uint32": "INTEGER",
            "uint64": "INTEGER",
            "float32": "DECIMAL",
            "float64": "DECIMAL",
            "bool": "BOOLEAN",
            "boolean": "BOOLEAN",
            "datetime64[us]": "TIMESTAMP",
        }

        nullable = " NOT NULL" if not bool(df[col].isnull().any()) else ""
        print(
            f"    {col_name} {dtype_map.get(df[col].dtype.name, df[col].dtype.name)}{nullable}{comma}"
        )
    print(");")

    print("#" * 50)

    # print SELECT MAX(LENGTH(<field>)) statement
    print("SELECT")
    for col in df.columns:
        col_name = col.upper().replace("-", "_").replace(" ", "_")
        if col == df.columns[-1]:
            comma = ""
        else:
            comma = ","
        print(f"    MAX(LENGTH({col_name})) {col_name}{comma}")
    print("FROM SCHEMA.TABLE;")
