git fsck --lost-found | grep "^dangling commit" | sed "s/^dangling commit //g" | xargs git show
