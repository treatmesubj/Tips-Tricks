"""
reads in a text file's lines as a list.
manipulates each line in the list.
writes resulting lines to an outfile in directory of infile
"""
import os
import sys


in_file = sys.argv[1]

# read infile as list of lines
with open(in_file) as f:
	ls = f.read().splitlines()

# iterate lines, manipulate them, write to outlist
out_ls = []
for row in ls:
	# out_ls.append(f"OR NAME LIKE '{row.strip()[:5]}%'")
	out_ls.append(f"{row.strip()[6:]}")
out_ls = set(out_ls) # take a set of the lines to remove dupes
print(out_ls)

# write out list to outfile
f = open(f"{os.path.dirname(in_file)}\\out_file.txt", 'w')
for line in out_ls:
	print(line)
	f.writelines(f"{line}\n")
f.close()