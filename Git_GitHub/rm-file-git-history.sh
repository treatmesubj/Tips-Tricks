# https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History
# https://github.com/newren/git-filter-repo
git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
