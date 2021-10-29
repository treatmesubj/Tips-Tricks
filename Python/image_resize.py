import os
import sys
from PIL import Image

"""
downsizes all images in directory to desired px width
"""

if __name__ == "__main__":
	if sys.argv[1] in ('-d', '--directory'):
		directory = sys.argv[2].strip("\"")
		files = os.listdir(directory)

	elif sys.argv[1] in ('-f', '--file'):
		file = sys.argv[2].strip("\"")
		files = [file,]
		directory = os.path.dirname(file)

	else:
		print("usage: python image_resize.py <-d|--directory|-f|--file> <file-path>")
		sys.exit()

	# print out image sizes before asking for width
	for file in files:
		full_file_path = os.path.join(directory, file)
		try:
			img = Image.open(full_file_path)
			print(file, img.size)
		except Exception as e:
			print(e)

	width_px = int(input("desired pixel width: "))

	# resize images
	for file in files:
		full_file_path = os.path.join(directory, file)
		try:
			img = Image.open(full_file_path)
			if img.size[0] > width_px:
				wpercent = (width_px / float(img.size[0]))
				hsize = int(float(img.size[1]) * float(wpercent))
				img = img.resize((width_px, hsize), Image.ANTIALIAS)
				img.save(full_file_path)
				print(f"{file} resized: {img.size}")
		except Exception as e:
			print(e)
