import os
import json
from pathlib import Path
import requests
from bs4 import BeautifulSoup
import browser_cookie3


if __name__ == "__main__":
    # extra troubleshooting: https://www.th3r3p0.com/random/python-requests-and-burp-suite.html
    # openssl x509 -inform der -in certificate.cer -out certificate.pem
    # cookiejar = browser_cookie3.load()
    cookiejar = browser_cookie3.firefox()
    #cookiejar = browser_cookie3.firefox(
    #    cookie_file="/mnt/c/Users/JohnHupperts/AppData/Roaming/Mozilla/Firefox/Profiles/zpg5udte.default-release/cookies.sqlite"
    #)

    proxies = {  # burpsuite
        'http': 'http://127.0.0.1:8080',
        'https': 'http://127.0.0.1:8080',
        #'http': 'http://172.31.48.1:6666',  # from wsl
        #'https': 'https://172.31.48.1:6666',  # from wsl
    }

    response_jobs = requests.get(
        "https://www.linkedin.com/jobs/search/?keywords=&location=United States&f_TPR=&f_WT=2",
        cookies=cookiejar,
        allow_redirects=True,
#        proxies=proxies,
#        verify="./cacert.pem"
    )

