import sys
import pandas as pd


if __name__ == "__main__":
	df = pd.read_parquet(sys.argv[1], engine='fastparquet')
	try:
		df.to_csv(sys.argv[2], index=False)
		print(sys.argv[2])
	except IndexError:
		df.to_csv(f"{sys.argv[1].split('.parquet')[0]}.csv", index=False)
		print(f"{sys.argv[1].split('.parquet')[0]}.csv")