import os
import sys


def get_dupes(seq):
    seen = set()
    seen_twice = set(x for x in seq if x in seen or seen.add(x))
    return seen_twice


def one_list_work(in_file):
    """
    change each row in a text-file of rows
    returns a list of the changed rows
    """

    with open(in_file) as f:
        in_ls = f.read().splitlines()
    in_set = set(in_ls)

    print(f"dupes: {get_dupes(in_ls)}")

    out_ls = []
    for row in in_set:
        #out_row = f"OR NAME LIKE '{row.strip()[:5]}%'"
        #out_row = f"'{row}',"
        out_row = f"TRIM({row}) {row}, "
        #out_row = f"{row.strip(',')}"
        print(out_row)
        out_ls.append(out_row)

    return out_ls


def two_list_work(in_file1, in_file2):
    """
    pair & change each row of two text-files of rows
    returns one list of paired & changed rows
    """

    with open(in_file1) as f1:
        in_ls1 = f1.read().splitlines()

    with open(in_file2) as f2:
        in_ls2 = f2.read().splitlines()

    paired_rows_list = [(in_ls1[i], in_ls2[i]) for i in range(0, len(in_ls1))]

    out_ls = []
    for pair in paired_rows_list:
        out_ls.append(f"WHEN COMPETENCY.AREAOFSPEC = '{pair[0]}' THEN '{pair[1]}'")

    return out_ls


if __name__ == "__main__":

    # one list work
    in_file = sys.argv[1]
    out_ls = one_list_work(in_file)
    out_dir = os.path.dirname(in_file)

#    # two list work
#    in_file1 = r"C:\Users\JohnHupperts\Desktop\comp_code.txt"
#    in_file2 = r"C:\Users\JohnHupperts\Desktop\comp_name.txt"
#    out_ls = two_list_work(in_file1, in_file2)
#    out_dir = os.path.dirname(in_file1)

    # write out list to outfile
    f = open(f"{out_dir}\\out_file.txt", 'w')
    for line in out_ls:
        f.writelines(f"{line}\n")
    f.close()
