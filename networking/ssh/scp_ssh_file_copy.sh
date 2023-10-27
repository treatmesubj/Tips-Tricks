# creates a local `./stuff/` directory for the files
# does not preserve symlinks! They're just normal files!
scp -r user@remote:/root/stuff .

# copies file from local to remote
scp ./my_file user@remote:/root/my_file
