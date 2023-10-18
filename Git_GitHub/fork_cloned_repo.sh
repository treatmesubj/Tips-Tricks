# Method 1
# fork repo in GitHub and clone fork
git remote add upstream git@github.com:<upstream-username>/<upstream-project>.git
git remote -v
git fetch upstream

#---
# Method 2
# clone upstream repo
git remote rename origin upstream
# create new repo in GitHub
git remote add origin git@github.com:<your-username>/<your-project>.git
git push -u origin master

