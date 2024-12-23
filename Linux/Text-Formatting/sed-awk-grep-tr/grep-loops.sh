#!/usr/bin/env bash

# grep list of strings in list of files
time ( parallel rg -io {2} {1} :::: <(rg -il 'WF360_HR\.DIM_EMPLOYEE\w+' .) wf360-dep-fields.txt )
time ( f=$(rg -il 'WF360_HR\.DIM_EMPLOYEE\w+' .); parallel rg -io {1} $f :::: wf360-dep-fields.txt )

time ( parallel grep -iHno {2} {1} :::: <(grep -irl -E 'WF360_HR\.DIM_EMPLOYEE\w+' .) wf360-dep-fields.txt )
time ( f=$(grep -irl -E 'WF360_HR\.DIM_EMPLOYEE\w+' .); parallel grep -iHno {1} $f :::: wf360-dep-fields.txt )
