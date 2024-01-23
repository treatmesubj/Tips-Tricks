rg -i -I -N 'namespace:' |                # grep for namespaces
    sed 's/^[ \t]*//;s/[ \t]*$//' |       # trim whitespace
    awk '!seen[$0]++'                     # rm dupes
