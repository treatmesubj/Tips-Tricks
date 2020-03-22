import requests
from requests_html import HTML

html = HTML(html=requests.get('https://www.bloomberg.com/series/bloomberg-real-yield').text)
print(html.html)
print(html.find("[href*='latest-episode']"))

########################################################3
import requests
from requests_html import HTML, HTMLSession
from pprint import pprint


headers = {  # from browser Network Request
	'Host': 'www.bloomberg.com',
	'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0',
	'Accept': '*/*',
	# 'Accept-Language': 'en-US,en;q=0.5',
	'Accept-Encoding': 'gzip, deflate, br',
	'Upgrade-Insecure-Requests': '1',
	# 'Connection': 'keep-alive',
	'Pragma': 'no-cache',
	'Cache-Control': 'no-cache',
	# 'Referer': 'https://www.bloomberg.com/series/bloomberg-real-yield',
	'TE': 'Trailers'
}


with HTMLSession() as session:
    r = session.get('https://www.bloomberg.com/news/videos/2020-03-13/-bloomberg-real-yield-full-show-03-13-2020-video', headers=headers)
    r.html.render()
    html_text = (r.html.html)
    # print(html_text)
    print(r.html.find("title", first=True).html, end='\n\n')
    # target = r.html.find("[href*='full-show']", first=True)
    # print(target)	
    for key, val in r.request.headers.items():
    	print(f"Request - {key}: ", val)
    print("~" * 20)
    for key, val in r.headers.items():
    	print(f"Response - {key}: ", val)
