find ./ -type f -name *.conf -exec ls -al {} \; 2>/dev/null

find / -type f -name *.conf -newermt 2020-03-03 -exec ls -al {} \; 2>/dev/null
