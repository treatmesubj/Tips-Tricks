# https://stackoverflow.com/a/44578276
git rebase -i HEAD~10
# change all your terrible commits from <pick> to <squash>
    # and they will be squashed UP into the prior picked commit

# if you're on a non-master branch
# you also might want to...
git pull -r origin master

# and if you've pushed to your branch
# you might need to re-write its history
git push --force
