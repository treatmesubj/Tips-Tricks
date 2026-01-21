#!/usr/bin/env python
import pandas as pd
import argparse

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("file", action="store")
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

# add this to path
"""
sudo cp ./csv-to-json.py /usr/local/bin/csv-to-json
"""

# diff 2 CSVs in bash:
"""
diff -u \
    <(csv-to-json old.csv -d rowCreateTs rowUpdateTs | jq) \
    <(csv-to-json new.csv -d rowCreateTs rowUpdateTs | jq) \
| delta
"""

