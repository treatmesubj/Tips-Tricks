#!/usr/bin/env bash

cat cool-file.txt | python -c "import sys; fmt = lambda str: str.upper(); print(*[fmt(line) for line in sys.stdin], sep='\n');"

# human readable cronjob schedules
kcrons() {
    pyscript="
import sys;
from cron_descriptor import get_description;
fmt = lambda str: str.split('\t')[0]+'\t'+get_description(str.split('\t')[1]);
print(*[fmt(line) for line in sys.stdin], sep='\n');
"
    k get cronjobs -o json \
    | jq -r '.items[] | {"name":.metadata.name, "schedule": .spec.schedule} | [.[]] | @tsv' \
    | python -c "$pyscript" \
    | column -t
}
