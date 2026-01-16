date +%s%3N  # Unix time - now milliseconds
date -d "yesterday" +%s%3N  # Unix time - yesterday milliseconds
date -d "tomorrow" +%s%3N  # Unix time - tomorrow milliseconds

# convert UTC timestamp to local time
date -d 'TZ="UTC" 2026-01-16T13:39:39'
