```bash
ls -la ~/.ssh
ssh-keygen -t ed25519 -C "it is my key for GitHub"
# Generating public/private ed25519 key pair.
# Enter file in which to save the key (/home/john/.ssh/id_ed25519): /home/john/.ssh/my_github_key
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:
# Your identification has been saved in /home/john/.ssh/my_github_key
# Your public key has been saved in /home/john/.ssh/my_github_key.pub
eval "$(ssh-agent -s)"  # start ssh-agent & set SSH_AUTH_SOCK env var
ssh-add ~/.ssh/my_github_key
git config --global user.name "treatmesubj"
git config --global user.email "jrock4503@hotmail.com"

cat ~/.ssh/my_github_key.pub
```

# add the public key to GitHub: https://github.com/settings/keys

# if git doesn't know which key to use, add below to `~/.ssh/config`
```
Host github.com
 HostName github.com
 IdentityFile ~/.ssh/my_github_key
```

```bash
ssh git@github.com
# PTY allocation request failed on channel 0
# Hi user! You've successfully authenticated, but GitHub does not provide shell access.
# Connection to github.com closed.
```
