curl -s https://wifi.delta.com/api/flight-data | jq -r '"https://maps.google.com/?q=\(.latitude),\(.longitude)"'
