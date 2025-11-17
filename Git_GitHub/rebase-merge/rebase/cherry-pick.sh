# take a commit from somewhere and play it on HEAD as new commit
git cherry-pick <hash>
# Auto-merging <file>
# Auto-merging <file>
# Auto-merging <file>
# Auto-merging <file>
# Auto-merging <file>

# messed up git log somehow, reset & play a series commits on master
git log-lil -10
git reset --hard origin/master
git cherry-pick <ref-a>^..<ref-b>  # from & including ref-a through ref-b
