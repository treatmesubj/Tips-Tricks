# see each changed file and its changes
git show
git diff HEAD~1 HEAD

# see just changed file names
git diff --stat HEAD~1 HEAD
git diff --name-only

# only show certain file(s) in git diff
git diff 154c4b9 HEAD -- ./epmingestion
# ignore file(s) in git diff; don't show their changes
git diff 44a65e HEAD -- ':!./pipelines/drafts/*'

# see staged, uncommitted files' changes
git add .
git diff --cached
git diff --staged
