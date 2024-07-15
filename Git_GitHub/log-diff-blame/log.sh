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

# only show file names changed
git log --name-only

# log of commits where regex string in it
git log -G regex # https://git-scm.com/docs/git-log#Documentation/git-log.txt--Gltregexgt
git log -S regex -p # https://git-scm.com/docs/git-log#Documentation/git-log.txt--Sltstringgt

# log across all branches by author
git log --all --stat --author="John.Hupperts@ibm.com"
# branches with last commit by author
git log-lil --all --simplify-by-decoration --date-order --author="John.Hupperts@ibm.com"
