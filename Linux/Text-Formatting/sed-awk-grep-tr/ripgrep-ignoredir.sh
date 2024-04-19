# ignore dirs
rg -ioI --no-line-number --no-heading 'EPM\w*\.\w+\s' -g '!old_releases/'\
    -g '!releases/' -g '!pre-release/' | sort -u > all-tables.txt

# only look in dirs
rg -ioI --no-line-number --no-heading 'EPM\w*\.\w+\s'\
    -g 'old_releases/2023/voldemort/**' | sort -u > voldemort-tables.txt
