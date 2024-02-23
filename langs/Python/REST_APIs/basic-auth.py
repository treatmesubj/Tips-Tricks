import requests
from requests.auth import HTTPBasicAuth
import os


url = "https://url/blah"
oslc_session = requests.Session()
oslc_session.params = {  # url query parameters
    "p1": "stuff",
    "p2": 10000,
    "pageno": 1,
}
oslc_session.auth = HTTPBasicAuth(
    os.getenv('USER'),
    os.getenv('PASS')
)
r = oslc_session.request("GET", url, timeout=600)
with open('out.json', 'w') as f:
    f.write(r.text)
