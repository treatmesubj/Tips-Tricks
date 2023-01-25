import os


def get_dirs_filepaths(dir_path):
    filenames = []
    for currentpath, folders, files in os.walk(dir_path):
        for file in files:
            if file.endswith(".xlsx"):
                filenames.append(os.path.join(currentpath, file))
    return filenames


if __name__ == "__main__":

    path = "~/my_directory"
    filenames = get_dirs_filepaths(path)
    print(filenames)

