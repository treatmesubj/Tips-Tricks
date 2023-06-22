import pandas as pd
import argparse
import os

# from pathlib import Path


parser = argparse.ArgumentParser()
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument("--excel_file", "-e", default=None, help="Excel file path")
group.add_argument("--csv_file", "-c", default=None, help="CSV file path")
args = parser.parse_args()


if args.excel_file:
    # file exists check
    if all((args.excel_file is not None, not os.path.isfile(args.excel_file))):
        raise FileNotFoundError(
            f"looks like the given `excel_file` argument's value - {args.excel_file} - cannot be found"
        )
    else:
        df = pd.read_excel(args.excel_file, dtype=str)

if args.csv_file:
    # file exists check
    if all((args.csv_file is not None, not os.path.isfile(args.csv_file))):
        raise FileNotFoundError(
            f"looks like the given `csv_file` argument's value - {args.csv_file} - cannot be found"
        )
    else:
        df = pd.read_csv(args.csv_file, dtype=str)

for col in df:
    print(col, "->", df[col].astype(str).str.len().max())
