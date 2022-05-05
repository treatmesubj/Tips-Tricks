from bs4 import BeautifulSoup
import os
from shutil import copyfile

# adds a link to html chapters of a textbook pointing to my dark-mode css file

files = os.listdir(os.getcwd())
print(files)

css_file = "phil_log.css"

"""
body {
	background-color: black;
}

path {
	fill: black;
}

div.page svg text {
	fill: white;
}
"""

os.makedirs(f"{os.getcwd()}\\dark")
copyfile("phil_log.css", f"{os.getcwd()}\\dark\\{css_file}")

for file in files:
	if ".html" == file[-5:]:
		print(f"working on {file}...")
		html = open(file, 'r', encoding='utf-8')
		soup = BeautifulSoup(html, features="lxml")
		new_link = soup.new_tag("link", rel="stylesheet", type="text/css", href=css_file)
		soup.head.append(new_link)

		with open(f"{os.getcwd()}\\dark\\{file}", "w", encoding="utf-8") as f:
			f.write(str(soup))
