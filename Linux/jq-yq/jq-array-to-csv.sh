    jq -r '.[] | [ keys[] as $k | .[$k] ] | @csv' inf.json >> outf.csv
