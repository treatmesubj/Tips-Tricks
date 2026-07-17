#!/usr/bin/env bash

rotate() {
    # arg or stdin?
    local text=${1:-'-'}
    if [ "$text" = "-" ]; then
        if [[ -t 0 ]]; then
            echo "waiting for terminal input; ctrl+D to submit" >&2
        fi
        text=$(</dev/stdin)
    fi
    local len=${#text}

    while true; do
        for ((i = 0; i < len; i++)); do
            s0=${text:i}
            s1=${text:0:i}

            printf '\r%s' "$s0$s1"
            sleep .1
        done
    done
}

if ( return 0 &>/dev/null ); then
    # we are being sourced
    return 0
else
    # we are being executed directly
    rotate "$@"
fi
