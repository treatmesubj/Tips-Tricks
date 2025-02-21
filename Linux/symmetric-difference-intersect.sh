# intersection of two lists
sort <(ls one) <(ls two) | uniq -d
sort file-1.txt file-2.txt | uniq -d

# symmetric difference of two lists
sort <(ls one) <(ls two) | uniq -u
sort file-1.txt file-2.txt | uniq -u
