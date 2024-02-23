git checkout feature
git config --global core.autocrlf false
git reset --hard origin/feature
git diff origin/master HEAD -- :dir/file
git reset origin/master dir/file
git status
git diff origin/master --staged -- :dir/file
git diff --satged
git commit -m 'fix newline issue'
git pull -r
git log
git push
