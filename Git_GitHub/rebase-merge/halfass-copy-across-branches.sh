# https://stackoverflow.com/a/25749155
# copy in files from another branch without a legitimate merge of commit history
git checkout feat1
git checkout feat2 special-dir/special-file  # simply copies in file from that branch
git add special-dir/special-file
git commit -m 'halfass merge of feat2'

# if you're going to merge feat2 into feat1 later, the files you copied will be
# no different, so there is no loss of commit history for those files anyway, so
# who cares
