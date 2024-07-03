pandoc -f jira -t gfm stuff.jira -o stuff.md
pandoc -f gfm -t jira README.md -o README.jira
