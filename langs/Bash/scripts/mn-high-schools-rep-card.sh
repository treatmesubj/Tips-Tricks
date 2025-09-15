#!/usr/bin/env bash

# get all high schools
curl -s "https://rc.education.mn.gov/ibi_apps/WFServlet?IBIAPP_app=rptcard_reports&IBIF_ex=rptcard_getfilter_orglist.fex&reportCode=9" \
    | yq -r -p json \
    '[ .schools | with_entries(select(.[].name | test("High$|High School"))).[] | {"id": key, "name": .name} ]' \
    -o tsv > schools.tsv

# chop headers
sed -i '1d' schools.tsv

# exclude junior highs
grep -v -i "junior" schools.tsv | sponge schools.tsv

IFS=$'\t'
while read -r line; do
    arr=( $(echo "$line") )
    schoolid=${arr[0]}
    schoolname=${arr[1]}
    echo $schoolid $schoolname
    # get school's data
    curl -s "https://rc.education.mn.gov/ibi_apps/WFServlet?IBIAPP_app=rptcard_reports&IBIF_ex=rptcard_getdata_myschool&orgName=Statewide&orgId=$schoolid&groupType=school" \
        | jq -r --arg schoolname $schoolname \
            '[ .dataSets.Assessment.data.[].[] ].[] + {"school": $schoolname} | [ keys[] as $k | .[$k] ] | @csv' \
            >> results.csv
    sleep 1
done < schools.tsv
unset IFS
