find ./ -type f -name '*.conf'
find ./ -type f -regex '.*\.conf'
find ./ -type f -iregex '.*\.CoNf'  # case insensitive
find / -type f -name '*.conf' -newermt 2020-03-03


find ./ -type f -name '*.conf' -exec ls -al {} \; 2>/dev/null
find ./ -type f --regex '.*\.conf' -exec ls -al {} \; 2>/dev/null
find / -type f -name '*.conf' -newermt 2020-03-03 -exec ls -al {} \; 2>/dev/null
