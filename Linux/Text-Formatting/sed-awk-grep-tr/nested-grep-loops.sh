#!/usr/bin/env bash

# nested grep loops
# grep list of strings in list of files
time ( parallel rg -io {2} {1} :::: <(rg -il 'WF360_HR\.DIM_EMPLOYEE\w+' .) wf360-dep-fields.txt )
time ( f=$(rg -il 'WF360_HR\.DIM_EMPLOYEE\w+' .); parallel rg -io {1} $f :::: wf360-dep-fields.txt )

time ( parallel grep -iHno {2} {1} :::: <(grep -irl -E 'WF360_HR\.DIM_EMPLOYEE\w+' .) wf360-dep-fields.txt )
time ( f=$(grep -irl -E 'WF360_HR\.DIM_EMPLOYEE\w+' .); parallel grep -iHno {1} $f :::: wf360-dep-fields.txt )

# checking for impact of deprecation of tables & fields
parallel --tty rg -g {1} -io {2} :::: <(rg -il wf360-prod) :::: wf360-dep-fields.txt
parallel --tty rg -g '{1}' -io "WF360_HR\.{2}\.*" :::: <(rg -il wf360-prod) :::: wf360-dep-tables.txt

# rg -il 'WF360_HR\.DIM_EMPLOYEE\w+' > dim-emp-files.txt
for f in $(cat dim-emp-files.txt); do
    echo -e "\n$f"
    echo "$(for i in $(cat wf360-dep-fields.txt);
            do rg -ioI --no-line-number --no-heading -g $f $i;
    done;)" | sort -fu;
done;
 parallel --tty rg -g {1} -io {2} :::: <(rg -il 'WF360_HR\.DIM_EMPLOYEE\w+') :::: wf360-dep-fields.txt
 parallel grep -iHno {2} {1} :::: <(grep -irl -E 'WF360_HR\.DIM_EMPLOYEE\w+' .) :::: wf360-dep-fields.txt
 f=$(grep -irl -E 'WF360_HR\.DIM_EMPLOYEE\w+' .); parallel grep -iHno {1} $f :::: wf360-dep-fields.txt
