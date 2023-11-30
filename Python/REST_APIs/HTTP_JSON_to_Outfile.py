import requests
import json
"""
fetches a JSON response via HTTP request and writes its pretty response to an outfile in same directory as working directory
"""


response = requests.get("http://www.site.com?thing.search/byjson?*")
sanjay = json.loads(response.text)


with open('./response.json', 'w') as f:
    print(json.dumps(sanjay, indent=4, sort_keys=True), file=f)
