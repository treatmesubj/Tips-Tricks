1. Create new repo & wiki in GitHub
2. Clone wiki 
3. Export Confluence Space to HTML Zip
4. Unzip/Decompress Confluence Space HTML Zip and move its files to Git dir.
   - `cd /mnt/c/Users/JohnHupperts/Downloads`
   - `unzip Confluence*.zip`
   - `mv ./RE360/* /mnt/c/JohnHupperts/Desktop/<name>.github.io/`
5. In Git dir., convert HTML to Markdown w/ Bash command
   - `find . -name "*.ht*" | while read i; do pandoc -f html -t gfm-raw_html "$i" -o "${i%.*}.md"; done`
6. Remove old HTML files: `find . -type f -name '*.html' -delete`
7. `cp index.md Home.md`
8. `git add .`, `git commit -m init`, `git push`
