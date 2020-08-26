import requests
import os

url = input("url: ")
file_name = input("file name & extension: ")

file_path = f"{os.getcwd()}\\{file_name}"
if os.path.exists(file_path):
	os.remove(file_path)
with open(file_path, "wb") as f:
	print("writing file...")
	f.write(requests.get(url).content)
print("done")