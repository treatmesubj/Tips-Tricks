#!/usr/bin/env bash
cool_one() { echo picked option one; }
cool_two() { echo picked option two; }
cool_three() { echo picked option three; }

menu() {
    options=(
        "option-a"
        "option-b"
        "option-c"
    )
    select opt in "${options[@]}"
    do
        case $opt in
            "option-a")
                cool_one
                ;;
            "option-b")
                cool_two
                ;;
            "option-c")
                cool_three
                ;;
            *) echo "invalid option";;
        esac
        break
    done
}

menu
