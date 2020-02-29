import requests
from requests_html import HTML

html = HTML(html=requests.get('https://www.bloomberg.com/series/bloomberg-real-yield').text)
print(html.html)
print(html.find("[href*='latest-episode']"))
