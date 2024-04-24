# intersection of two lists
sort <(ls one) <(ls two) | uniq -d

# symmetric difference of two lists
sort <(ls one) <(ls two) | uniq -u
