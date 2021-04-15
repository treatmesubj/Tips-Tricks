import os
import subprocess
import getpass
import sys
import datetime
import time
import pygetwindow

"""
Writes a QMF procedure and calls it via QMF OS command-line API to run a query
and export its results to an Excel file: query-path\\<today's date>\\<Excel results>
If QMF is already open, it just writes a new process for the query & opens it up with QMF GUI
"""

try:
	if len(sys.argv) > 1:
		query_path = sys.argv[1].replace("\"", "")
	else:
		query_path = input("file-path of query: ").replace("\"", "")

	query_name = os.path.basename(query_path).split(".")[0]
	query_dir = os.path.dirname(query_path)
	process_path = f"{query_dir}\\{query_name}_process.prc"

	today_date = datetime.date.today().strftime("%m.%d.%y")
	if not os.path.exists(f"{query_dir}\\{today_date}"):
		os.makedirs(f"{query_dir}\\{today_date}")

	excel_results_path = f"{query_dir}\\{today_date}\\{query_name}_results.xlsx"
	if os.path.exists(excel_results_path):
		os.remove(excel_results_path)

	# write the QMF process
	with open(process_path, "w") as file:
		file.write("".join(line for line in (
			f"IMPORT QUERY FROM \"{query_path}\"\n",
			"RUN QUERY\n",
			f"EXPORT DATA TO \"{excel_results_path}\" (DATAFORMAT=XLSX"
			)))

	# QMF CLI doesn't use the system path list, I guess
	exceutable_path = r"C:\Program Files\IBM\DB2 Query Management Facility v12.1\QMF for Workstation\qmfdev.exe"

	# QMF CLI opens processes in new QMF instances for some annoying reason
	# so, best you can do is use OS to open the process in the same instance
	if not any("QMF for Workstation" in win for win in pygetwindow.getAllTitles()):
		# Run QMF procedure via QMF OS command-line API
		subprocess.call("".join(f"\"{param}\" " for param in (
			exceutable_path,
			f"/RConnection:My Repository",
			process_path,
			"/IServer:AMLoad & SMS",
			"/Run",
			f"/IUserID:{input('data-source user-ID: ')}",
			f"/IPassword:{getpass.getpass('data-source user-password: ')}"
			)).strip())

		sleeps = 0
		while not os.path.exists(excel_results_path):
			print(f"QMF doing work{sleeps*'.'}", end="\r")
			sleeps+=1
			time.sleep(1.5)
		else:
			# guess QMF doesn't change file privileges when writing file,
			# so this will attempt to open a big file prematurely sometimes
			# but causes no issues, just annoying
			while not os.access(excel_results_path, os.W_OK):
				print("QMF is writing file...", end="\r")
				pass
			os.startfile(excel_results_path)

	else:
		os.startfile(process_path)

except Exception as e:
	print(e)
