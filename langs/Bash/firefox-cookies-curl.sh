#!/usr/bin/env bash

if grep -qi microsoft /proc/version; then
    windows_user=$(powershell.exe '$Env:UserName')
    profiles_dir="/mnt/c/Users/${windows_user//$'\r'/}/AppData/Roaming/Mozilla/Firefox/Profiles"
else
    profiles_dir="$HOME/.mozilla/firefox"
fi

cookies_sqlite=$(ls -t1 $profiles_dir/*/cookies.sqlite | head -1)
tmp_cookies_sqlite=$(mktemp /tmp/cookies.sqlite.XXXXXXXXXX)
tmp_cookies_txt=$(mktemp /tmp/cookies.txt.XXXXXXXXXX)
cat "$cookies_sqlite" >> "$tmp_cookies_sqlite"

sqlite3 -separator $'\t' $tmp_cookies_sqlite > "$tmp_cookies_txt" <<- EOF
.mode tabs
.header off
select host,
case substr(host,1,1)='.' when 0 then 'FALSE' else 'TRUE' end,
path,
case isSecure when 0 then 'FALSE' else 'TRUE' end,
expiry,
name,
value
from moz_cookies;
EOF

curl -b "$tmp_cookies_txt" "https://www.google.com"
