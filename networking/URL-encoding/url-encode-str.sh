# url encode a string
echo -n "$mystring" | jq -sRr @uri
jq -Rr @uri <<< "$mystring"
