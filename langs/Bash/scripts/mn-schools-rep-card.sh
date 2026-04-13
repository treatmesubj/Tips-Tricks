#!/usr/bin/env bash

# get all schools
curl -s "https://rc.education.mn.gov/ibi_apps/WFServlet?IBIAPP_app=rptcard_reports&IBIF_ex=rptcard_getfilter_orglist.fex&reportCode=9" > all-schools.json

# filter for high schools or Wayzata district
# filter="Wayzata"
filter="High$|High School"
yq -r -p json '[ .schools | with_entries(select(.[].name | test(strenv(filter)))).[] | [key, .name] ]' \
    -o tsv < all-schools.json > schools.tsv

# exclude junior highs
grep -v -i "junior" schools.tsv | sponge schools.tsv

# fetch & write out results
IFS=$'\t'
while read -r line; do
    arr=( $(echo "$line") )
    schoolid=${arr[0]}
    schoolname=${arr[1]}
    echo "$schoolid" "$schoolname"
    # get school's data
    curl -s "https://rc.education.mn.gov/ibi_apps/WFServlet?IBIAPP_app=rptcard_reports&IBIF_ex=rptcard_getdata_myschool&orgName=Statewide&orgId=$schoolid&groupType=school" \
        | jq -r --arg schoolname "$schoolname" \
            '[ .dataSets.Assessment.data.[].[] ].[] + {"school": $schoolname} | [ keys[] as $k | .[$k] ] | @csv' \
            >> results.csv
    sleep 1
done < schools.tsv
unset IFS

# add headers
sed -i '1i\subject_code,subject_name,year,proficient_count,proficient_percent,proficient_percent,school_name,tested_count' results.csv
