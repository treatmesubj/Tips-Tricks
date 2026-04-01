curl -G --write-out "%{url_effective}\n"  \
    'http://example.com' \
    -H 'accept: application/json' \
    -H "Content-Type: application/json" \
    --data-urlencode selector='
    {
      "environment": "production",
      "configurations.url": "cos://cool/transform.parquet/"
    }' | jq
