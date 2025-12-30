# Process substitution allows a process's input or output
# to be referred to using a filename
#
# $ cat ./script.sh
# echo hey
# ((1/0))

# redirect ./script.sh's file-descriptor-1 to stdout.txt and file-descriptor-2 to stderr.txt
./script.sh 1> stdout.txt 2> stderr.txt

# redirect ./script.sh's fd1 (stdout) to cat's stdin
#   and ./script.sh's fd2 (stderr) to tee's stdin
# (tee redirects its stdin to stdout as well as a file)
./script.sh 1> >(cat) 2> >(tee stderr.txt)



# in below,
     cat <(uname)
# <(uname) expands to a named-pipe containing the stdout of uname
# i.e.
#   cat /dev/fd/63
# e.g.
    cat <(whoami) <(uname)
#   john
#   Linux

# in below,
    uname 1> >(cat)
# >(cat) expands to
#   cat <named-pipe>
# where <named-pipe> is a file containing the stdout of uname
# i.e.
#   cat /dev/fd/63
# e.g.
    echo {a..e} | xargs -r printf '<%s>\n' \
        | tee >(grep a 1> a.out) >(grep c 1> c.out) >(grep e 1> e.out) \
    && ls a.out c.out e.out
        # <a>
        # <b>
        # <c>
        # <d>
        # <e>
        # ls: cannot access 'a.out': No such file or directory
        # c.out  e.out
