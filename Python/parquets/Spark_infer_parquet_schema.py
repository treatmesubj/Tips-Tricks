from pyspark.sql import SparkSession
import argparse
import os


parser = argparse.ArgumentParser()
parser.add_argument("--file", "-f", required=True, help="parquet file path")
args = parser.parse_args()

if not os.path.isfile(args.file):
    raise FileNotFoundError(
        f"looks like the given `file` argument's value/path - {args.file} - cannot be found"
    )

spark = SparkSession.builder.getOrCreate()
df = spark.read.parquet(args.file, header=True, inferSchema=True)
df.printSchema()
ddl = spark.sparkContext._jvm.org.apache.spark.sql.types.DataType.fromJson(df.schema.json()).toDDL()
print(ddl)
