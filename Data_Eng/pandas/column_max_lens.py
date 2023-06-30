import pandas as pd
import argparse
import os


# https://www.techiedelight.com/round-next-highest-power-2/
def round_power_of_2(n: int):
    # decrement `n` (to handle cases when `n` itself
    # is a power of 2)
    n = n - 1

    # do 'til only one bit is left
    while n & n - 1:
        n = n & n - 1  # unset rightmost bit

    # `n` is now a power of two (less than `n`)

    # return next power of 2
    return n << 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--excel_file", "-e", default=None, help="Excel file path")
    group.add_argument("--csv_file", "-c", default=None, help="CSV file path")
    group.add_argument("--parquet_file", "-p", default=None, help="parquet file path")
    args = parser.parse_args()

    if args.excel_file:
        # file exists check
        if all((args.excel_file is not None, not os.path.isfile(args.excel_file))):
            raise FileNotFoundError(
                f"looks like the given `excel_file` argument's value/path - {args.excel_file} - cannot be found"
            )
        else:
            df = pd.read_excel(args.excel_file, dtype=str)

    if args.csv_file:
        # file exists check
        if all((args.csv_file is not None, not os.path.isfile(args.csv_file))):
            raise FileNotFoundError(
                f"looks like the given `csv_file` argument's value/path - {args.csv_file} - cannot be found"
            )
        else:
            df = pd.read_csv(args.csv_file, dtype=str)

    if args.parquet_file:
        # file exists check
        if all((args.parquet_file is not None, not os.path.isfile(args.parquet_file))):
            raise FileNotFoundError(
                f"looks like the given `parquet_file` argument's value/path - {args.parquet_file} - cannot be found"
            )
        else:
            df = pd.read_parquet(args.parquet_file)
            # print(df.info(verbose=True)) col types

    # print max lens
    for col in df:
        print(col, "->", df[col].astype(str).str.len().max())

    print("#" * 50)

    # print approximate DDL
    for col in df.columns[:-1]:
        print(f"{col.upper().replace('-', '_')} VARCHAR({round_power_of_2(df[col].astype(str).str.len().max())}),")
    print(f"{df.columns[-1].upper().replace('-', '_')} VARCHAR({round_power_of_2(df.iloc[:,-1].astype(str).str.len().max())})")
