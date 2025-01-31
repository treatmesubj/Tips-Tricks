# Git Blame w/ Delta
- `git blame git-diff.sh`
```txt
Blaming lines: 100% (15/15), done.
6 months ago    treatmesubj     02cf6c99│  1 │ # see each changed file and its changes
                                        │  2 │ git show
3 weeks ago     treatmesubj     7e22bb5e│  3 │ git diff HEAD~1 HEAD
6 months ago    treatmesubj     02cf6c99│  4 │
                                        │  5 │ # see just changed file names
3 weeks ago     treatmesubj     7e22bb5e│  6 │ git diff --stat HEAD~1 HEAD
6 months ago    treatmesubj     40c1bede│  7 │ git diff --name-only
2 weeks ago     treatmesubj     34a25842│  8 │
4 days ago      treatmesubj     0a763e1f│  9 │ # ignore file(s) in git diff; don't show their changes
                                        │ 10 │ git diff 44a65e HEAD -- ':!./pipelines/drafts/*'
                                        │ 11 │
2 weeks ago     treatmesubj     34a25842│ 12 │ # see staged, uncommitted files' changes
                                        │ 13 │ git add .
                                        │ 14 │ git diff --cached
                                        │ 15 │ git diff --staged
```

- `git blame -L 9,13 git-diff.sh`
    - honorary mention: `git log -L 9,13:git-diff.sh`
```text
4 days ago      treatmesubj     0a763e1f│  9 │ # ignore file(s) in git diff; don't show their changes
                                        │ 10 │ git diff 44a65e HEAD -- ':!./pipelines/drafts/*'
                                        │ 11 │
2 weeks ago     treatmesubj     34a25842│ 12 │ # see staged, uncommitted files' changes
                                        │ 13 │ git add .
```

- `git blame -w -C -C -C git-diff.sh  # ignore refactors, basically`
- `git config --global alias.blame-hard 'blame -w -C -C -C'`
    - ignore whitespace
    - detect lines moved/copied in same commit
        - or commit that created file
        - or any commit at all

## review your feat-branch commits for a file
```bash
git blame $(git merge-base master HEAD)...HEAD -- file.sh
git blame $(git merge-base master feat)...feat -- file.sh
```
