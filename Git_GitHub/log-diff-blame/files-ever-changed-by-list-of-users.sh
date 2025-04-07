changed_files=$(
    git log --name-only --oneline \
    --author="\(user1@gmail.com\)\|\(user2@gmail.com\)\|\(user3@gmail.com\)" \
    --regexp-ignore-case \
    --pretty="format:" -- dir/subdir/ \
    | sort -u \
    | sed -r '/^\s*$/d'
)
echo "$changed_files"
echo "---"
while read -r line; do
    yq '.key.key2_id' $line
done <<< $changed_files
