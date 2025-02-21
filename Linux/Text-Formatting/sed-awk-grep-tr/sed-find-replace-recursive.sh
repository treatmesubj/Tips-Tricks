# find replace
find . -type f -name "*.yaml" -exec sed -i'' -e 's+/home/john/Documents/Thesaurus_Rex/docker+/mnt/c/Users/JohnHupperts/Documents/Programming_Projects/Thesaurus_Rex/docker+g' {} +
