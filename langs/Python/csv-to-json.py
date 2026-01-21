#!/usr/bin/env python
import pandas as pd
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", "-f", action="store")
    parser.add_argument(
        "--drops",
        "-d",
        nargs="+",
        type=str,
        default=[],
        help="A list of columns to drop (e.g., -d rowCreateTs rowUpdateTs)",
    )
    args = parser.parse_args()

    df = pd.read_csv(args.file).drop(columns=args.drops)
    print(df.to_json(orient="columns"))

# diff 2 CSVs in bash:
"""
diff -u \
    <(./csv-to-json.py -f old.csv -d rowCreateTs rowUpdateTs | jq) \
    <(./csv-to-json.py -f new.csv -d rowCreateTs rowUpdateTs | jq) \
| delta
"""
