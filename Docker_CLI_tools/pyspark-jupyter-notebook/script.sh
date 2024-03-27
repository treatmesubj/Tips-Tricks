#!/usr/bin/env bash
neofetch

if ! test -d /mount-dir; then
    echo "sorry, no /mount-dir"
else
    cat /mount-dir/home.txt
fi

source ~/.venv_spark/bin/activate
source /container-dir/env.sh
jupyter notebook --ip 0.0.0.0 --no-browser --allow-root

sleep 99
