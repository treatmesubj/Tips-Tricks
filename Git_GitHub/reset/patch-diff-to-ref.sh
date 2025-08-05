# diff HEAD and another ref, then patch that diff as a commit
git diff HEAD bf03c11b1c > revert_changes.patch
git apply revert_changes.patch && rm revert_changes.patch
git add .
git commit -m 'patch changes'
