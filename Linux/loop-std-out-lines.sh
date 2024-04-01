ls -1 | while read line; do echo $line; done

# git log | grep 'commit ' | cut -d ' ' -f2 | while read line; do git show $line; done | grep "secret"

# rename files (file-123 -> 123)
ls -1 | while read filename; do num=$(echo $filename | cut -d '-' -f2) && mv $filename $num; done
