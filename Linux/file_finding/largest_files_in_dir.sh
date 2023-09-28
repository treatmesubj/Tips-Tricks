du -a . | sort -n -r | head -n 20

sizeup() {
    if [ $# -eq 1 ]  # file path arg
    then
        path=$(readlink -m $1)
        if [ -d $path ]  # directory
        then
            du -sh $path/* $path/.[^.]* 2>/dev/null | sort -hr
        else
            du -sh $path | sort -hr
        fi
    else
        du -sh * .[^.]* 2>/dev/null | sort -hr
    fi
}

sizeup

