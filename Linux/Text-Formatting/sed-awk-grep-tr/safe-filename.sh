# safe filename
echo -n "$doc-$database.json" | sed -e 's/[^A-Za-z0-9._-]/_/g'
