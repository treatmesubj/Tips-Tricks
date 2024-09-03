# git log-lil
git log --pretty=\"format:%C(yellow)%h %C(Cyan)%>(10)%ad (%cr) %Cgreen%aN%Cred%d %Creset%s\" --date=short

# Ascii Tree
git log --graph --pretty=oneline --abbrev-commit

# log of commits pertaining to file
git log path/to/file
# log of commits pertaining to certain lines in file
git log -L 14,26:path/to/file
# log of commits pertaining to file, with diffs
git log -p -- filename my-file.txt

# only show file names changed relative to cwd
git log --name-only --relative

# log of commits where regex string in it
git log -G regex # https://git-scm.com/docs/git-log#Documentation/git-log.txt--Gltregexgt
git log -S regex -p # https://git-scm.com/docs/git-log#Documentation/git-log.txt--Sltstringgt

# log across all branches by author
git log --all --stat --author="John.Hupperts@ibm.com"
# branches with last commit by author
git log-lil -10 --all --simplify-by-decoration --date-order --author="John.Hupperts@ibm.com"

####
# Reference logs, record when the tips of branches and other references were updated in the local repo
git reflog
# undo a rebase
git reset --hard HEAD@{2}

# This will take all commits on topic that aren't on master
# and replay them on top of 0deadbeef, an old commit in master
git rebase --onto 0deadbeef master topic
