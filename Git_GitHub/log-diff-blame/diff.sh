# see each changed file and its changes
git show
git diff HEAD~1 HEAD

# https://stackoverflow.com/questions/462974/what-are-the-differences-between-double-dot-and-triple-dot-in-git-com
# two dot, 2 dot, three dot, 3 dot
# see commits in feature-branch after shared common ancestor w/ origin/master
git diff origin/master...feature-branch --name-only --relative
git diff $(git merge-base master feature-branch)...feature-branch --name-only --relative
# see commit-content delta in feature-branch or origin/master after common ancestor
# (what's in feature-branch that is not in master)
git diff origin/master..feature-branch --name-only --relative

# see just changed file names
git diff --stat HEAD~1 HEAD
git diff --name-only

# only show certain file(s) in git diff
git diff 154c4b9...HEAD -- ./epmingestion
# ignore file(s) in git diff; don't show their changes
git diff 44a65e...HEAD -- ':!./pipelines/drafts/*'

# diff 2 files with different names
git diff --no-index <path> <path>

# diff revision & plain working-tree file
git diff master -- file.sh

# see staged, uncommitted files' changes
git add .
git diff --cached
git diff --staged

# diff from 3 days ago
git diff 'HEAD@{3 days ago}' HEAD ./headcount-monthly-static-fact.yaml
git checkout 'HEAD@{one week ago}' job-category-dimension.yaml
