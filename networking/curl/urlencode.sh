# use basic auth to execute a GET request with url encoded query paramaters
curl --get -u $user:$pass "https://my.api.com/stuff"\
    --data-urlencode "param1={cool: sweet}"\
    --data-urlencode "param2=nice"\
    | jq > output.json

# execute a POST request with url encoded data
curl "https://my.api.com/stuff"\
    --data-urlencode "param1={cool: sweet}"\
    --data-urlencode "param2=nice"\
    | jq > output.json

