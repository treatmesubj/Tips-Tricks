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
	'Accept-Language': 'en-US,en;q=0.5',
	'Accept-Encoding': 'gzip, deflate, br',
	# 'Upgrade-Insecure-Requests': '1',
	'Connection': 'keep-alive',
	'referer': 'https://www.bloomberg.com/series/bloomberg-real-yield'
	# 'Cookie': '__sppvid=9374b553-40c7-44b2-8f7a-15ee77202929; bbAbVisits=1; _cc_cc=ctst; optimizelyEndUserId=oeu1584811771046r0.4639515334213389; bdfpc=004.9909423136.1584811772330; _reg-csrf=s%3AZYQil9Fz29Eh1okIo3asKyAA.S3IsiOfUN3Nn5BvDh8qivArWSYyP8CWLuu5HYbuqZmM; _reg-csrf-token=DdSk10SE-4vqxcSQGx_kj-Ru2jNgkNxZi7TY; agent_id=4072918b-fb62-4dbd-b3b3-9cd568425ed6; session_id=e7ced246-6abe-40fa-bb1a-89c69bc1a83b; session_key=176f736c7366aa32a49735bd3128180989fc8ff7; _user-status=anonymous; _is-ip-whitelisted=false; _gcl_au=1.1.999073391.1584811773; _user_newsletters=[]; _li_dcdm_c=.bloomberg.com; _lc2_fpi=b1166d620485--01e3z2956kzypkzq0zkre6hb09; _pxvid=8733f1d4-6b99-11ea-bdb6-0242ac120005; _pxde=ed46d0b0545d6411b111a5217beca064588366651e235d6071ced5328c1a188a:eyJ0aW1lc3RhbXAiOjE1ODQ4MTI1MDQzMjIsImZfa2IiOjAsImlwY19pZCI6W119; notice_behavior=implied|us; __tbc=%7Bjzx%7Dt_3qvTkEkvt3AGEeiiNNgHjayiJbfBGHmRWVx-9vCUI6JsI4isNN0eECJfxqZnWyP2ZmUg8FweslheC1MyQJ24uutav0tSys9J1HWLt7R1Z-B-zWdeazZL3ei2ORm7UqjylU0Z664w9lha1BgkmqDg; __pat=-14400000; __pvi=%7B%22id%22%3A%22v-2020-03-21-12-29-35-385-c1sGTQz99swzmNjk-37d7cce01b16b6e99aa54c9291f7eda5%22%2C%22domain%22%3A%22.bloomberg.com%22%2C%22time%22%3A1584811776844%7D; xbc=%7Bjzx%7DwIyDQW5uccDRGDzYaiXb8zMyreZlHR2PSv_c7YmrYJEd5Qae6DiphvepeVT5u0buOK29lWNa6XAYmX5qrGQKxvpkNInDZ5iXA1SDTeZOr0jQYPzuH1T5511r1kIjWpXTy_zkbO2RUKzl4NEFIegwJPrLrgQs1lO7VrSy8fXw8NuYkgplvEHsyhiuzwh6DQt66gjX1fkhdUxI2CwdheT4jZBCC9aFK96g3hvYPqnqW-fcUZBtjsO3udk-w7TvFhoL40i1OnMVOQTnbTIam5xTJQ5cLTmuG_fFcRkc6GCTnRXyoxHNq0TCl0gVs3rxvI-Na4J3gbJD5oyu2tGr2xMuYTlFS7rsYhEALiaaavV09ew; _parsely_visitor={%22id%22:%2223b3a9f0-9b20-4867-8d2f-47ac7d59afec%22%2C%22session_count%22:1%2C%22last_session_ts%22:1584811777407}; _parsely_session={%22sid%22:1%2C%22surl%22:%22https://www.bloomberg.com/series/bloomberg-real-yield%22%2C%22sref%22:%22%22%2C%22sts%22:1584811777407%2C%22slts%22:0}; _ga=GA1.2.128669381.1584811778; _gid=GA1.2.1497869105.1584811778; _px2=eyJ1IjoiODZlMzQwZjAtNmI5OS0xMWVhLWE2OGYtNGJlNjZhMDlkNDU4IiwidiI6Ijg3MzNmMWQ0LTZiOTktMTFlYS1iZGI2LTAyNDJhYzEyMDAwNSIsInQiOjE1ODQ4MTI4MDQzMjEsImgiOiI2M2NiMGM1OTIyYTY3ZWU0M2RjNDQ4Y2MzMGEyNDA5MTdiZGFlNTc1MjMzODZjZjI1ZDExMzAxYjA3NGIzZDhlIn0=; _px3=7aeafcfd4f7d3a33bbe9b2353e0b91d3c522fe289fb7bbd561f8bc1a80d4c742:5pF1UZbNNApIcN9Vv6N0/UzwHs6ONuENT4Gvqdq5phIqKKelnvTDuby0OL0pAE0i21C+7/Ug0O1MtyxKm/Zg+A==:1000:tMfqSV6V7EZ9HpxizjuAJLU1SJN6V7q0KZrOhAn4hM0Tdkhac8evsiMR7m2g5lhu0q/DErUcebDkWmnYcdn8kVct+DuP/i2sc/euKaHjcVR9XOwDPGuEaIoEbYhRZzhI3DAVFIUE5eQKuhC10UpApD9kLBN90+o2VrD6iXuEh1g=; _fbp=fb.1.1584811779528.1327455469; _cc_dc=0; _cc_id=16cb582c5b99c9b307a18ab49c73ad79',
	# 'If-None-Match': 'W/"rO9P1f1DP0ilp8wVPbOMfQ=="',
	# 'TE': 'Trailers'
}

with HTMLSession() as session:
    r = session.get('https://www.bloomberg.com/series/bloomberg-real-yield', headers=headers)
    r.html.render()
    html_text = (r.html.html)
    print(r.html.find("title", first=True).html)
    # target = r.html.find("[href*='full-show']", first=True)
    # print(target)
