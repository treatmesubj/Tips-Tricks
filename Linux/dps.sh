#!/usr/bin/env bash

zips=(
    "76575", "78610", "78612", "78613", "78615", "78617", "78619", "78620",
    "78628", "78634", "78641", "78645", "78652", "78653", "78654", "78660",
    "78665", "78669", "78681", "78701", "78702", "78703", "78704", "78705",
    "78717", "78721", "78722", "78723", "78724", "78726", "78728", "78731",
    "78732", "78733", "78734", "78735", "78736", "78737", "78738", "78739",
    "78741", "78744", "78745", "78746", "78747", "78748", "78749", "78750",
    "78751", "78752", "78753", "78754", "78756", "78757", "78758", "78759"
)

for zip in "${zips[@]}"
do
    curl -k 'https://apptapi.txdpsscheduler.com/api/AvailableLocation'\
        --compressed -X POST\
        -H 'Accept: application/json, text/plain, */*'\
        -H 'Accept-Language: en-US,en;q=0.5'\
        -H 'Accept-Encoding: gzip, deflate, br, zstd'\
        -H "Authorization: $auth"\
        -H 'Content-Type: application/json;charset=utf-8'\
        -H 'Origin: https://public.txdpsscheduler.com'\
        -H 'Connection: keep-alive'\
        -H 'Referer: https://public.txdpsscheduler.com/'\
        -H 'Sec-Fetch-Dest: empty'\
        -H 'Sec-Fetch-Mode: cors'\
        -H 'Sec-Fetch-Site: same-site'\
        -H 'Priority: u=0'\
        --data-raw '{"TypeId":81,"ZipCode":"'$zip'","CityName":"","PreferredDay":0}'\
    | yq '.[] |= omit(["Availability"]) | sort_by(.NextAvailableDateYear, .NextAvailableDateMonth, .NextAvailableDateDay)'\
    | yq '.[] |= pick(["Id", "Name", "Address", "NextAvailableDate"])'\
    | jq -r '.[] | [ keys[] as $k | .[$k] ] | @csv' >> out.csv
head -5 out.csv
sleep 2
done
