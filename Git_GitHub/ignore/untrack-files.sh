# personally, don't track a yet untracked file
echo "<file>" >> .git/info/exclude
# shared-repo, don't track a file; requires commit
echo "<file>" >> .gitignore
# personally, don't track a file, period
git update-index --assume-unchanged <file-list>
# git update-index --no-assume-unchanged <file-list>
