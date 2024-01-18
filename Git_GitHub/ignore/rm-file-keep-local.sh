git rm --cached file.txt  # rm remote
git status
echo 'file.txt' >> .git/info/exclude  # don't track again
git status
