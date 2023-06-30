import pyspark.sql.functions as f

"""
>>> df.toPandas()
Traceback
  File "/home/john/.venv_spark/lib/python3.11/site-packages/pyspark/sql/types.py", line 279, in fromInternal
    return datetime.datetime.fromtimestamp(ts // 1000000).replace(microsecond=ts % 1000000)
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
ValueError: year 0 is out of range


can convert bad timestamp column to string column
"""

df = df.withColumn("UNIQUE_FEATURE_CODE_LASTUPDATED_TIMESTAMP", f.from_unixtime(f.unix_timestamp(df.UNIQUE_FEATURE_CODE_LASTUPDATED_TIMESTAMP), "yyyy-MM-dd"))

df = df.withColumn("LAST_MODIFIED_TIMESTAMP", f.from_unixtime(f.unix_timestamp(df.LAST_MODIFIED_TIMESTAMP), "yyyy-MM-dd"))

 df = df.withColumn("AUDIT_TIMESTAMP", f.from_unixtime(f.unix_timestamp(df.AUDIT_TIMESTAMP), "yyyy-MM-dd"))
