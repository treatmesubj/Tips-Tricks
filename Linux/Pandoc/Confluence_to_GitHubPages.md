1.  Create new repo in GitHub: `<name>.github.io`
2.  Clone repo
3.  Export Confluence Space to HTML Zip
4.  Unzip/Decompress Confluence Space HTML Zip and move its files to Git
    dir.
    - `cd /mnt/c/Users/JohnHupperts/Downloads`
    - `unzip Confluence*.zip`
    - `mv ./RE360/* /mnt/c/JohnHupperts/Desktop/<name>.github.io/`
5.  In Git dir., convert HTML to Markdown w/ Bash command
    - `find . -name "*.ht*" | while read i; do pandoc -f html -t gfm-raw_html "$i" -o "${i%.*}.md"; done`
6.  Remove old HTML files: `find . -type f -name '*.html' -delete`
7.  Create a default jekyll layout file - `_layouts/default.html` - with below contents
    ```    
    <!doctype html>
    <html>
      <head>
        <style>
            body { background-color: #272822; color: white; font-family: Courier; }
            a[href] { color: #66d9ef; }
            code { color: #ae81ff; background-color: #272b33; border-radius: 6px; }
        </style>
        <meta charset="utf-8">
        <title>{{ page.name }}</title>
      </head>
      <body>
        <a href="{{site.github.repository_url}}/tree/master/{{page.path}}">Edit This Document</a>
        {{ content }}
      </body>
    </html>
    ```
8.  `git add .`, `git commit -m init`, `git push`
9.  In GitHub web UI, repo settings, turn on GitHub Pages for `master` branch & `/ (root)`
