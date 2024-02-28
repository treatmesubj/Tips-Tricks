# https://stackoverflow.com/questions/3065650/whats-the-simplest-way-to-list-conflicted-files-in-git
git diff --name-only --diff-filter=U --relative && echo "---" && git diff --check
git config --global alias.show-merge-conflicts '!git diff --name-only --diff-filter=U --relative && echo "---" && git diff --check'
