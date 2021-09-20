"""
reads in a text file's lines as a list.
manipulates each line in the list.
writes resulting lines to an outfile in directory of infile
"""
import os
import sys


def get_dupes(seq):
    seen = set()
    seen_twice = set(x for x in seq if x in seen or seen.add(x))
    return seen_twice


in_file = sys.argv[1]

# read infile as list of lines
with open(in_file) as f:
	in_ls = f.read().splitlines()
in_set = set(in_ls)

print(f"dupes: {get_dupes(in_ls)}")

# iterate lines, manipulate them, write to outlist
out_ls = []
for row in in_set:
	# out_ls.append(f"OR NAME LIKE '{row.strip()[:5]}%'")
	out_ls.append(f"|{row}|")
	# out_ls.append(f"{row.strip(',')}")
	# out_ls += [topic.strip() for topic in row.split(',')]

# write out list to outfile
f = open(f"{os.path.dirname(in_file)}\\out_file.txt", 'w')
for line in out_ls:
	print(line)
	f.writelines(f"{line}\n")
f.close()
