f = open('dummy.txt', 'r')
ls = f.readlines()
f.close()
new_ls = []

for row in ls:
	new_ls.append(row.split('WSDIW.')[1].strip())

print(new_ls)

f = open('outfile.txt', 'w')
for line in new_ls:
	f.writelines(f"{line}\n")
f.close()