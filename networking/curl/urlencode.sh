# use basic auth to execute a GET request with url encoded query paramaters
# -v will echo full encoded URL
curl -v --get -u $user:$pass "https://my.api.com/stuff"\
    --data-urlencode "param1={cool: sweet}"\
    --data-urlencode "param2=nice"\
    | jq > output.json

# execute a POST request with url encoded data
# -v will echo full encoded URL
curl -v "https://my.api.com/stuff"\
    --data-urlencode "param1={cool: sweet}"\
    --data-urlencode "param2=nice"\
    | jq > output.json

