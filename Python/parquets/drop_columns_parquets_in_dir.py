"""
drop columns from all parquets in directory
& write them to a new directory
"""
import os
import sys
import pyarrow.parquet as pq


def main(source_dir, target_dir):
	for root, dirs, files in os.walk(source_dir):
		for file in files:
			path_file = os.path.join(root, file)
			target_file = os.path.join(target_dir, f"{file}")
			print(target_file)
			f = pq.ParquetFile(path_file)
			try:
				cleaned_t = f.read().drop(["__index_level_0__",])
			except KeyError:
				try:
					cleaned_t = f.read().drop(["dmtRef",])
				except KeyError:
					cleaned_t = f.read()
			cleaned_t = cleaned_t.drop(["disbursed.claimCreationDate",])
			cleaned_t = cleaned_t.cast(cleaned_t.schema.remove_metadata()) # remove metadata crap
			pq.write_table(cleaned_t, target_file)


def get_schema(parquet_file_path):
	f = pq.ParquetFile(parquet_file_path)
	schema = f.read().schema
	return schema


if __name__ == "__main__":
	source_dir = sys.argv[1]
	target_dir = sys.argv[2]
	# global_schema = get_schema(sys.argv[3])
	main(source_dir=source_dir, target_dir=target_dir)