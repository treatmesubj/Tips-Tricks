# encrypt w/ passphrase
gpg -c ./hi.txt
# provide passphrase in GUI
# creates ./hi.txt.gpg

# GPG caches passphrases for user's current logged in session;
# restart the GPG agent to clear cache
gpg-connect-agent reloadagent /bye

# decrypt the file
gpg -d ./hi.txt.gpg
# gpg: AES256.CFB encrypted data
# gpg: encrypted with 1 passphrase
# hey there

# decrypt file and output contents to a new file
gpg -d --output ./out.txt ./hi.txt.gpg
cat ./out.txt
# hey there
