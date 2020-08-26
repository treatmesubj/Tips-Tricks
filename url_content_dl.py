import requests
import os


urls = (
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%201_001.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%201_002.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%201_003.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%201_004.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%202_001.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%202_002.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%202_003.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%202_004.mp3",
	r"http://the-eye.eu/public/AudioBooks/Richard%20Dawkins%20-%20The%20Selfish%20Gene/The%20Selfish%20Gene%20Unabridged%202_005.mp3"
	)

for idx, url in enumerate(urls):

	file_name = f"Selfish_Gene_{str(idx)}.mp3"
	file_path = f"{os.getcwd()}\\{file_name}"
	if os.path.exists(file_path):
		os.remove(file_path)
	with open(file_path, "wb") as f:
		print(f"writing {file_name}...")
		f.write(requests.get(url).content)
	print("done")