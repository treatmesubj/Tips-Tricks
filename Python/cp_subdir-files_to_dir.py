import os
import sys
import shutil
import datetime
from datetime import date
import re


def regex_date(string):
	"""
	returns a %Y-%m-%d date from a string
	"""
	match = re.search(r'\d{4}-\d{2}-\d{2}', string)
	date = datetime.datetime.strptime(match.group(), '%Y-%m-%d').date()
	return date


def main(source_dir, target_dir):
	"""
	Copies all files from a directory and its sub-directories
	to a target directory.
	"""
	for root, dirs, files in os.walk(source_dir):
		for file in files:
			path_file = os.path.join(root, file)
			# shutil.copy2(path_file, target_dir)
			target_file = os.path.join(target_dir, f"{regex_date(path_file)}.parquet")
			print(target_file)
			shutil.copy2(path_file, target_file)


if __name__ == "__main__":
	source_dir = sys.argv[1]
	target_dir = sys.argv[2]
	main(source_dir=source_dir, target_dir=target_dir)
