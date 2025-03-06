#!/usr/bin/env python3
import pyarrow.parquet as pq


# https://arrow.apache.org/docs/python/generated/pyarrow.parquet.read_table.html
table = pq.read_table('my.snappy.parquet')
print(table.schema)
# https://arrow.apache.org/docs/python/generated/pyarrow.parquet.write_table.html
pq.write_table(table, 'out.snappy.parquet', compression='snappy', use_deprecated_int96_timestamps=True)
for i in pq.read_metadata('out.snappy.parquet').schema:
    print(i)
