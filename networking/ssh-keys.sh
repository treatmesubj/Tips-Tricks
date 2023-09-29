ls ~/.ssh  # don't overwrite a key
ssh-keygen -b 4096
# Generating public/private rsa key pair.
# Enter file in which to save the key (/home/john/.ssh/id_rsa): /home/john/.ssh/my_key
# Enter passphrase (empty for no passphrase):
# Enter same passphrase again:

# copy public key over to server
ssh-copy-id -i ~/.ssh/my_key.pub user@remote  # -n (dry-run)

# if local ssh doesn't know/realize which key to use, add below to `~/.ssh/config`
#```
#Host remote.server
# HostName remote.server
# IdentityFile ~/.ssh/my_key
#```
