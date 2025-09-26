#!/usr/bin/env bash

# identifies single-quoted-strings containing a space
# which span over col 90

file="$1"

awk '{
    in_quote = 0
    quote_start = -1
    for (i = 1 ; i <= length($0); i++) {
        c = substr($0, i, 1)
        if (c == "'\''") {
            if (in_quote == 0) {
                in_quote = 1
                quote_start = i
            } else {
                # closing quote
                if (quote_start <= 90 && i >= 90) {
                    stringy = substr($0, quote_start, i - quote_start + 1)
                    if (stringy ~ /'"'"'.*\s.*'"'"'/) {
                        printf "Line %d: quote spans column 90 (from col %d to col %d)\n", NR, quote_start, i
                        print stringy
                        print substr($0, 0, 100)
                        print "\n"
                    }
                }
                in_quote = 0
            }
        }
    }
}' "$file"
