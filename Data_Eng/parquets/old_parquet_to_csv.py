import sys
import os
import pandas as pd
import pyarrow.parquet as pq


def parquet_to_csv(in_file, out_file=None):
    """
    Creates a CSV file from parquet file.
    If no desired resulting CSV file-path is given,
    the CSV is created in the directory of the parquet file.
    """
    df = pd.read_parquet(in_file, engine="fastparquet")
    print(df.head())
    df.columns = df.columns.astype(str)
    if out_file:
        df.to_csv(out_file, index=False)
        print(out_file)
    else:
        pre, ext = os.path.splitext(in_file)
        out_file = f"{pre}.csv"
        df.to_csv(out_file, index=False)
        print(out_file)
    return df


def print_df_column_lengths(df):
    for col in df.columns:
        try:
            print(f"{col}: {df[col].str.len().max()}")
        except AttributeError:
            print(col)


if __name__ == "__main__":
    in_file = sys.argv[1]
    try:
        out_file = sys.argv[2]
    except IndexError:
        out_file = None
    df = parquet_to_csv(in_file=in_file, out_file=out_file)
    print_df_column_lengths(df)
    table = pq.read_table(in_file)
