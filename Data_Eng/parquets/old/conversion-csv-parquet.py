#!/usr/bin/env python3
import sys
import os
import argparse
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq


def parquet_to_csv(in_file, out_file):
    """
    Creates a CSV file from parquet file.
    If no desired resulting CSV file-path is given,
    the CSV is created in the directory of the parquet file.
    """
    df = pd.read_parquet(in_file, engine="fastparquet")
    print(df.head())
    df.columns = df.columns.astype(str)
    df.to_csv(out_file, index=False)
    print(out_file)
    return df


def csv_to_parquet(in_file, out_file, partition_cols=None):
    """
    Creates a parquet file from CSV file.
    If no desired resulting parquet file-path is given,
    the parquet is created in the directory of the CSV file.
    """
    df = pd.read_csv(in_file)
    print(df.head())
    df.columns = df.columns.astype(str)
    df.to_parquet(out_file, engine="fastparquet", partition_cols=partition_cols)
    print(out_file)

    # parquet_schema = pa.Table.from_pandas(df=df).schema
    # parquet_writer = pq.ParquetWriter(
    #     out_file, parquet_schema, compression="snappy"
    # )
    # table = pa.Table.from_pandas(df, schema=parquet_schema)
    # parquet_writer.write_table(table)
    # print(out_file)
    # parquet_writer.close()

    return df


def print_df_column_lengths(df):
    print("string col max lens")
    for col in df.columns:
        try:
            print(f"{col}: {df[col].str.len().max()}")
        except AttributeError:
            print(f"{col}: -")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    direction_group = parser.add_mutually_exclusive_group(required=True)
    direction_group.add_argument("--csv-to-parquet", "-cp", action="store_true")
    direction_group.add_argument("--parquet-to-csv", "-pc", action="store_true")
    parser.add_argument("--in-file", "-i", action="store", required=True)
    parser.add_argument(
        "--parquet-partitions",
        "-pp",
        action="store",
        help='comma separated list, e.g. "YEAR, QUARTER, MONTH"',
    )
    parser.add_argument("--out-file", "-o", action="store")
    args = parser.parse_args()

    if not args.out_file:
        pre, ext = os.path.splitext(args.in_file)
        if args.parquet_to_csv:
            out_file = f"{pre}.csv"
        if args.csv_to_parquet:
            out_file = f"{pre}.snappy.parquet"
    else:
        out_file = args.out_file

    if args.csv_to_parquet:
        if args.parquet_partitions:
            partition_cols = [x.strip() for x in args.parquet_partitions.split(",")]
            print(f"{partition_cols=}")
        df = csv_to_parquet(
            in_file=args.in_file, out_file=out_file, partition_cols=partition_cols
        )
    if args.parquet_to_csv:
        df = parquet_to_csv(in_file=args.in_file, out_file=out_file)

    print_df_column_lengths(df)
