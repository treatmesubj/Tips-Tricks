import win32api
import requests
import os

url = input("url: ")
file_name = input("file name & extension: ")

dir_loc = f"C:\\Users\\{win32api.GetUserName()}\\Desktop"
file_path = f"{dir_loc}\\{file_name}"
if os.path.exists(file_path):
	os.remove(file_path)
with open(file_path, "wb") as f:
	print("writing file...")
	f.write(requests.get(url).content)
print("done")