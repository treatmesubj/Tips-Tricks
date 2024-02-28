# examples
git config --global alias.blame-hard 'blame -w -C -C -C'
git config --global alias.checkout-fzf '!git checkout $(git branch | fzf)'
git config --global alias.show-merge-conflicts '!git diff --name-only --diff-filter=U --relative && echo "---" && git diff --check'
