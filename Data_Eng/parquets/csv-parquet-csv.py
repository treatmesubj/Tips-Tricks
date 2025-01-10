#!/usr/bin/env python3
import os
import argparse
from pyspark.sql import SparkSession


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    direction_group = parser.add_mutually_exclusive_group(required=True)
    direction_group.add_argument("--csv-to-parquet", "-cp", action="store_true")
    direction_group.add_argument("--parquet-to-csv", "-pc", action="store_true")
    parser.add_argument(
        "--in-file",
        "-i",
        nargs="+",
        action="store",
        required=True,
        help="file-path, or multiple file-paths in shared directory",
    )
    parser.add_argument("--out-file", "-o", action="store")
    args = parser.parse_args()

    if len(args.in_file) > 1:
        in_file = f"{os.path.dirname(args.in_file[0])}/*"
    else:
        in_file = args.in_file

    if not args.out_file:
        pre, ext = os.path.splitext(in_file)
        if args.parquet_to_csv:
            out_file = f"{pre.replace('*', 'data')}.csv"
        if args.csv_to_parquet:
            out_file = f"{pre}.snappy.parquet"
    else:
        out_file = args.out_file

    print(f"{in_file=}")
    print(f"{out_file=}")
    spark = SparkSession.builder.getOrCreate()

    # https://spark.apache.org/docs/latest/sql-data-sources-parquet.html#data-source-option
    # https://spark.apache.org/docs/latest/sql-data-sources-csv.html#data-source-option
    if args.csv_to_parquet:
        df = spark.read.option("header", True).csv(args.in_file)
        df.printSchema()
        print(df.head())
        df.write.parquet(out_file)
    if args.parquet_to_csv:
        df = spark.read.parquet(in_file)
        df.printSchema()
        print(df.head())
        df.coalesce(1).write.option("header", True).csv(out_file)
