Generate a PAT
https://github.com/settings/tokens

```bash
# cache creds for 7 days
git config credential.helper 'cache --timeout=604800'

# HTTPS, not ssh
vim .git/config
# [remote "origin"]
#   url = https://github.com/<user>/<repo>.git

git pull
# Username for 'https://github.com': <username>
# Password for 'https://<username>@github.com': <PAT>
```
