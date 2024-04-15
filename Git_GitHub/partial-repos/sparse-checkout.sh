mkdir <repo>
cd <repo>
git init

git config core.sparseCheckout true
echo "subdir/dir/dir" >> .git/info/sparse-checkout
echo "another-subdir/dir/dir" >> .git/info/sparse-checkout
# **NOTE**: repo's name is not 'top-level' dir in sparse-checkout path

git remote add origin <.git url>
# git fetch --depth 1 origin master  # for massive monorepos
git fetch origin master
git checkout master

git status
git log
