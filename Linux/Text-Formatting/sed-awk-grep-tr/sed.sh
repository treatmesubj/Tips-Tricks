sed 's/to_change/changed/' infile.txt   # find and replace
sed 's,to_change,changed,' infile.txt   # find and replace (comma delimeter instead of slash)
sed 's/to_change//' infile.txt          # find and remove
echo "to_change" | sed 's/to_change/changed/'

sed -e 's/to_change/changed/' -e 's/changed/chaned_again/' infile.txt  # use multiple scripts
