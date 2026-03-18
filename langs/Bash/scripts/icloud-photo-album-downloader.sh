#!/usr/bin/env bash

# https://www.icloud.com/sharedalbum/#A90GXZcak9tb7cJ

curl -s 'https://p127-sharedstreams.icloud.com/A90GXZcak9tb7cJ/sharedstreams/webstream' \
  --compressed \
  -X POST \
  -H 'Accept: */*' \
  -H 'Content-Type: text/plain' \
  -H 'Origin: https://www.icloud.com' \
  -H 'Referer: https://www.icloud.com/' \
  --data-raw '{"streamCtag":null}' | jq > webstream.json

guids=$(jq '{"photoGuids": [.photos[].photoGuid]}' webstream.json)
big_photo_checksums=$(jq '[.photos[].derivatives | to_entries | sort_by(.key)[0].value.checksum]' webstream.json)

curl -s 'https://p127-sharedstreams.icloud.com/A90GXZcak9tb7cJ/sharedstreams/webasseturls' \
  --compressed \
  -X POST \
  -H 'Accept: */*' \
  -H 'Content-Type: text/plain' \
  -H 'Origin: https://www.icloud.com' \
  -H 'Connection: keep-alive' \
  -H 'Referer: https://www.icloud.com/' \
  --data-raw "$guids" | jq > webassets.json

jq --argjson keys "$big_photo_checksums" \
    '.items | to_entries | map(select(.key | IN($keys[]))) | from_entries' webassets.json \
    > big-webassets.json

parallel curl {} -H 'Accept: image/*' --output-dir photos --create-dirs -O \
    :::: <(jq -r '.[] | ("https://" + .url_location + .url_path)' big-webassets.json)
