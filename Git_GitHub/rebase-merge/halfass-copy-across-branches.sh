# https://stackoverflow.com/a/25749155
# copy in files from another branch (rather than doing a legitimate merge of
# commit history & files)
# WILL OVERWRITE FILES in working directory
git checkout feat1
git checkout feat2 special-dir/special-file  # simply copy in file from that branch & stage it
git status
git commit -m 'halfass copy/merge of feat2'

# if you're going to merge feat2 into feat1 later, the files you copied will be
# no different, so there is no loss of commit history for those files anyway, so
# who cares
