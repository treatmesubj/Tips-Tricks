import random
import requests
from bs4 import BeautifulSoup
# import webbrowser
import subprocess


if __name__ == "__main__":
    url = 'https://builtin.com/jobs/remote/mid-level'
    html = requests.get(url).text
    soup = BeautifulSoup(html, 'html.parser')

    last_page = int(soup.select("li[class='mx-xs page-item'] a")[-1].text)

    rand_page = random.randint(1, last_page)

    rand_url = f"{url}?page={rand_page}"
    # webbrowser.open_new_tab(rand_url)

    subprocess.call(f"powershell.exe python -m webbrowser -t {rand_url}", shell=True)


