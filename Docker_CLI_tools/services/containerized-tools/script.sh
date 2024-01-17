#!/usr/bin/env bash
neofetch

if ! test -d /mount-dir; then
    echo "sorry, no /mount-dir"
    echo "try: docker run -it -v ./local-dir/:/mount-dir containerized-tools"
else
    cat /mount-dir/home.txt
fi

sleep 99
