# change author going forward
git config user.name "John Doe"
git config user.email "john@doe.org"

# change last commit's author
git commit --amend --author="John Doe <john@doe.org>"

# reset author for a given commit's BASE_SHA and all following commits:
git rebase -i BASE_SHA -x \
  "git commit --amend --author 'John Doe <johndoe@example.com>' -CHEAD"
