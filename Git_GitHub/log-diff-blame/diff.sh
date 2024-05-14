# see each changed file and its changes
git show
git diff HEAD~1 HEAD

# see changes between branches
git diff origin/master...HEAD --name-only
# see changes between branches - show file-paths relative to cwd
git diff origin/master...HEAD --name-only --relative

# see just changed file names
git diff --stat HEAD~1 HEAD
git diff --name-only

# only show certain file(s) in git diff
git diff 154c4b9 HEAD -- ./epmingestion
# ignore file(s) in git diff; don't show their changes
git diff 44a65e HEAD -- ':!./pipelines/drafts/*'

# diff 2 files with different names
git diff --no-index <path> <path>

# see staged, uncommitted files' changes
git add .
git diff --cached
git diff --staged

# diff from 3 days ago
git diff 'HEAD@{3 days ago}' HEAD ./headcount-monthly-static-fact.yaml

##########
# GitHub #
##########
# https://github.ibm.com/<user>/<repo>/compare/master..feature
# https://github.ibm.com/<user>/<repo>/compare/master..bda3d2
# https://github.ibm.com/<user>/<repo>/compare/a8xua9..bda3d2
