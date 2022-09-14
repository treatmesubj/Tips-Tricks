import sys
import os
import pandas as pd


def parquet_to_csv(in_file, out_file=None):
	"""
	Creates a CSV file from parquet file.
	If no desired resulting CSV file-path is given,
	the CSV is created in the directory of the parquet file.
	"""
	df = pd.read_parquet(in_file, engine='fastparquet')
	if out_file:
		df.to_csv(out_file, index=False)
		print(out_file)
	else:
		pre, ext = os.path.splitext(in_file)
		out_file = f"{pre}.csv"
		df.to_csv(out_file, index=False)
		print(out_file)


if __name__ == "__main__":
	in_file = sys.argv[1]
	try:
		out_file = sys.argv[2]
	except IndexError:
		out_file = None
	parquet_to_csv(in_file=in_file, out_file=out_file)