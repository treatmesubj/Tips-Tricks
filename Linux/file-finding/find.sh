find ./ -type f -name '*.conf'
find ./ -type f -regex '.*\.conf'
find ./ -type f -iregex '.*\.CoNf'  # case insensitive
find / -type f -name '*.conf' -newermt 2020-03-03

# ignore files
find . -type f -not -name "*.html"
# ignore directories
find . -not -path "./.git/*"

# delete files
find . -name "*.pdf" -delete

# execute commands
find ./ -type f -name '*.conf' -exec ls -al {} \; 2>/dev/null
find ./ -type f --regex '.*\.conf' -exec ls -al {} \; 2>/dev/null
find / -type f -name '*.conf' -newermt 2020-03-03 -exec ls -al {} \; 2>/dev/null
find . -type f -not -path "./.git/*" -exec dos2unix {} \;
