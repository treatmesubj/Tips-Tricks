for i in $(ls -1); do echo $i; done

for i in $(ls -1); do tar -czvf $i.tar.gzip $i; done
