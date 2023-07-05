import pandas as pd
import argparse
import os


# https://www.techiedelight.com/round-next-highest-power-2/
def round_power_of_2(n: int):
    # decrement `n` (to handle cases when `n` itself
    # is a power of 2)
    if n > 1:
        n = n - 1

    # do 'til only one bit is left
    while n & n - 1:
        n = n & n - 1  # unset rightmost bit

    # `n` is now a power of two (less than `n`)

    # return next power of 2
    return n << 1


def nargs_req_len(nmin,nmax):
    class RequiredLength(argparse.Action):
        def __call__(self, parser, args, values, option_string=None):
            if not nmin<=len(values)<=nmax:
                breakpoint()
                msg=f"argument '{self.dest}' requires between {nmin} and {nmax} arguments\n{self.help}"
                raise argparse.ArgumentTypeError(msg)
            setattr(args, self.dest, values)
    return RequiredLength


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        "--excel_file", "-e", nargs='+', action=nargs_req_len(1,2), help="Excel file path & sheet name; {-e file.xlsx my_sheet}"
    )
    group.add_argument("--csv_file", "-c", help="CSV file path")
    group.add_argument("--parquet_file", "-p", help="parquet file path")
    args = parser.parse_args()

    if args.excel_file:
        # file exists check
        if not os.path.isfile(args.excel_file[0]):
            raise FileNotFoundError(
                f"looks like the given `excel_file` argument's value/path - {args.excel_file[0]} - cannot be found"
            )
        if len(args.excel_file) == 1:
            args.excel_file += [None,]
            print("no sheet name given; default to 1st sheet\n")
        df = pd.read_excel(args.excel_file[0], sheet_name=args.excel_file[1], dtype=str)

    if args.csv_file:
        # file exists check
        if not os.path.isfile(args.csv_file):
            raise FileNotFoundError(
                f"looks like the given `csv_file` argument's value/path - {args.csv_file} - cannot be found"
            )
        df = pd.read_csv(args.csv_file, dtype=str)

    if args.parquet_file:
        # file exists check
        if not os.path.isfile(args.parquet_file):
            raise FileNotFoundError(
                f"looks like the given `parquet_file` argument's value/path - {args.parquet_file} - cannot be found"
            )
        df = pd.read_parquet(args.parquet_file)
        # print(df.info(verbose=True)) col types

    # print max lens
    for col in df:
        print(col, "->", df[col].astype(str).str.len().max())

    print("#" * 50)

    # print approximate DDL
    for col in df.columns[:-1]:
        print(
            f"{col.upper().replace('-', '_')} VARCHAR({round_power_of_2(df[col].astype(str).str.len().max())}),"
        )
    print(
        f"{df.columns[-1].upper().replace('-', '_')} VARCHAR({round_power_of_2(df.iloc[:,-1].astype(str).str.len().max())})"
    )
