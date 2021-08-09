import os
from PIL import Image

"""
downsizes all images in directory to 1000px width
"""

if __name__ == "__main__":
	# run from folder of images
	directory = input("pictures folder: ").strip("\"")
	for file in os.listdir(directory):
		full_file_path = os.path.join(directory, file)
		try:
			img = Image.open(full_file_path)
			print(full_file_path, img.size)
			if img.size[0] > 1000:
				wpercent = (1000 / float(img.size[0]))
				hsize = int(float(img.size[1]) * float(wpercent))
				img = img.resize((1000, hsize), Image.ANTIALIAS)
				img.save(full_file_path)
		except Exception as e:
			print(e)
