# unstage a file
git restore --staged file-to-unstage.txt

# unstages any files added since last commit
git reset --soft HEAD~1

# unstage local files & commits, pull remote changes, but keep local changes
git reset HEAD^
git pull --rebase --autostash
