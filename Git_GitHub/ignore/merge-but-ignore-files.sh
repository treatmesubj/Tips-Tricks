git checkout main
git merge --no-ff --no-commit feat-branch  # merge branch without creating a commit
git reset HEAD file-to-ignore.txt  # un-stage file
git checkout -- file-to-ignore.txt  # discard any changes made by the merge
# or if new file to branch, just do: rm file-to-ignore.txt
git commit -m "merged feat-branch"

# copy file from another branch without staging
git restore --source master-johnh run-uif-on-cluster.sh
