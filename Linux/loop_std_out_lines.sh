ls -1 | while read line; do echo $line; done

# git log | grep 'commit ' | cut -d ' ' -f2 | while read line; do git show $line; done | grep "secret"


