"""
reads in a text file's lines as a list.
manipulates each line in the list.
writes resulting lines to an outfile in directory of infile
"""
import os
import sys


in_file = sys.argv[1]

# read infile as list of lines
f = open(in_file, 'r')
ls = f.readlines()
f.close()
out_ls = []

# iterate lines, manipulate them, write to outlist
for row in ls:
	# new_ls.append(row.split('WSDIW.')[1].strip())
	out_ls.append(row.strip().upper())
print(out_ls)

# write out list to outfile
f = open(f"{os.path.dirname(in_file)}\\out_file.txt", 'w')
for line in out_ls:
	f.writelines(f"{line}\n")
f.close()