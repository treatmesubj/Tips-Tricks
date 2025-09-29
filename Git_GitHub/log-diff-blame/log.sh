# git log-lil
git log --pretty=\"format:%C(yellow)%h %C(Cyan)%>(10)%ad (%cr) %Cgreen%aN%Cred%d %Creset%s\" --date=short

# Ascii Tree
git log --graph --pretty=oneline --abbrev-commit

# number of commits by email, sorted; get all committers
git shortlog -e -s -n

# pertaining to file
git log path/to/file
# pertaining to certain lines in file
git log -L 14,26:path/to/file

# excluding/igonring files
git log -p -- ':!.secrets.baseline' ':!poetry.lock' ':!pyproject.toml'

# log of commits, with diffs, with merges diff'd as 1 commit
git log -p --first-parent -m

# pertaining to file, with diffs
git log -p -- filename my-file.txt

# only show file names changed relative to cwd
git log --name-only --relative

# where regex string in commit diff
git log -p -G regex # https://git-scm.com/docs/git-log#Documentation/git-log.txt--Gltregexgt
git log -p -S string # https://git-scm.com/docs/git-log#Documentation/git-log.txt--Sltstringgt

# where regex in commit message
git log -p --grep=regex

# pickaxe; where string in commit contents
git log -i -Sstring --oneline -- path/file.yaml

# log by author
git log -p --author="John.Hupperts@ibm.com"
# log across all branches by author
git log --all --stat --author="John.Hupperts@ibm.com"
git log --all --stat --author=".*john.*" --regexp-ignore-case
# branches with last commit by author
git log-lil -10 --all --simplify-by-decoration --date-order --author="John.Hupperts@ibm.com"

# commits in feat-branch since branching off master
git log-lil master..feat-branch

####
# Reference logs, record when the tips of branches and other references were updated in the local repo
git reflog
# undo a rebase
git reset --hard HEAD@{2}

# This will take all commits on topic that aren't on master
# and replay them on top of 0deadbeef, an old commit in master
git rebase --onto 0deadbeef master topic
