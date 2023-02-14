import os
import sys
from PIL import Image

"""
downsizes all images in directory-path or an image file-path to desired px width and puts them in a new ./resized directory
"""

class DirFileArgError(Exception):
    def __str__(self):
        return "Invalid directory/file flag before file-path"

if __name__ == "__main__":

    try:
        dir_file_flag = sys.argv[1]
        if dir_file_flag in ('-d', '--directory'):
            directory_path = sys.argv[2].strip("\"").strip("/")
            file_names = os.listdir(directory_path)
        elif dir_file_flag in ('-f', '--file'):
            file_path = sys.argv[2].strip("\"").strip("/")
            file_names = [os.path.basename(file_path),]
            directory_path = os.path.dirname(file_path)
        else:
            raise DirFileArgError
    except (IndexError, DirFileArgError) as command_error:
        print("\nusage: python image_resize.py <-d|--directory|-f|--file> <file-path> <-w|--width|-h|--height>\n\n")
        raise command_error

    if directory_path == '':
        directory_path = '.'

    # print out image sizes before asking for width
    for file_name in file_names:
        full_file_path = os.path.join(directory_path, file_name)
        try:
            img = Image.open(full_file_path)
            print(file_name, img.size)
        except Exception as opening_image_file_error:
            if dir_file_flag in ('-f', '--file'):
                raise opening_image_file_error
            else:
                print(f"{file_name}: e")
    try:
        if sys.argv[3] in ['-w', '--width']:
            width_px = int(input("desired pixel width: "))
            height_px = None
        if sys.argv[3] in ['-h', '--height']:
            height_px = int(input("desired pixel height: "))
            width_px = None
    except IndexError as e:
        print("\nusage: python image_resize.py <-d|--directory|-f|--file> <file-path> <-w|--width|-h|--height>\n\n")
        raise e

    # resize images
    for file_name in file_names:
        full_file_path = os.path.join(directory_path, file_name)
        try:
            img = Image.open(full_file_path)
            if width_px:
                wpercent = (width_px / float(img.size[0]))
                hsize = int(float(img.size[1]) * float(wpercent))
                img = img.resize((width_px, hsize), Image.LANCZOS)
            elif height_px:
                hpercent = (height_px / float(img.size[1]))
                wsize = int(float(img.size[0]) * float(hpercent))
                img = img.resize((wsize, height_px), Image.LANCZOS)
            out_dir_path = f"{directory_path}/resized"
            if not os.path.exists(out_dir_path):
                os.mkdir(out_dir_path)
            out_file_path = os.path.join(out_dir_path, file_name)
            img.save(out_file_path)
            print(f"{file_name} resized: {img.size}")
        except Exception as e:
            print(f"{file_name}: {e}")
            raise e
