find . -name "*.ht*" | while read i; do pandoc -f html -t gfm-raw_html "$i" -o "${i%.*}.md"; done
