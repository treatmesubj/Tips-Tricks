import pandas as pd
import argparse
import os
# from pathlib import Path


parser = argparse.ArgumentParser()
parser.add_argument("--excel_file", "-f", default=None, help="Excel file path")
args = parser.parse_args()


if args.excel_file and all(
    (args.excel_file != "none", not os.path.isfile(args.excel_file))
):
    raise FileNotFoundError(
        f"looks like the given `excel_file` argument's value - {args.excel_file} - cannot be found"
    )



df = pd.read_excel(args.excel_file, dtype=str)
for col in df:
    print(col, "->", df[col].astype(str).str.len().max())
