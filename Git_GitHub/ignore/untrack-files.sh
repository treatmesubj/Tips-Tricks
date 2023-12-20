# update .gitignore
git add .gitignore
git commit -m "gitignore"
git update-index --assume-unchanged <file-list>
git status
# desired ignored files not tracked

##############################
# start tracking files again #
##############################
# update .gitignore
git add .gitignore
git commit -m "gitignore"
git update-index --no-assume-unchanged <file-list>
git status
# desired files tracked, not staged
