mkdir <repo>
cd <repo>
git init
git remote add -f origin <.git url>

git config core.sparseCheckout true

echo "subdir/dir/dir" >> .git/info/sparse-checkout
echo "another-subdir/dir/dir" >> .git/info/sparse-checkout
# **NOTE**: repo's name is not 'top-level' dir in sparse-checkout path

git pull origin <branch>
