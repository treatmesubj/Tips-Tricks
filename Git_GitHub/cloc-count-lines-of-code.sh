# https://github.com/AlDanial/cloc
# dir
cloc ./repo/

# each sub-dir in dir
for d in ./*/ ; do (cd "$d" && echo "$d" && cloc --vcs git); done
