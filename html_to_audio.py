from bs4 import BeautifulSoup
from gtts import gTTS
import os

directory = input("Book Directory: ").strip("\"")

for chapter in os.listdir(directory):
	with open(os.path.join(directory, chapter), encoding="utf-8") as f:
		html = f.read()
	soup = BeautifulSoup(html, 'html.parser')
	chapter_text = " ".join(paragraph.text for paragraph in soup.select("p"))
	while True:
		try:
			speech = gTTS(text=chapter_text, lang='en', slow=False)
			speech.save(os.path.join(directory, f"{os.path.splitext(chapter)[0]}.mp3"))
			print(f"{chapter} done...")
			break
		except Exception as e:
			print(f"		{e}...")