"""
adapted from https://gist.github.com/denis-bz/88611952815b56b5b8b5
    & https://gist.github.com/Tblue/62ff47bef7f894e92ed5
"""

import os
import json
import lz4.block
from pathlib import Path


# Windows
firefox_dir = Path(os.path.expanduser('~'), 'AppData', 'Roaming', 'Mozilla', 'FireFox', 'Profiles')
prof_dir = next(firefox_dir.glob("*.default-release"))
sess_cookies_json_file = Path(prof_dir, 'sessionstore-backups', 'recovery.jsonlz4')


def decompress(file_obj):
    if file_obj.read(8) != b"mozLz40\0":
        raise ValueError("Invalid magic number")

    return lz4.block.decompress(file_obj.read())


if __name__ == "__main__":
    with open(sess_cookies_json_file, mode='rb') as file:
        sanjay = json.loads(decompress(file))

    cookies = {cookie['name']: {'host': cookie['host'], 'value': cookie['value']} for cookie in sanjay['cookies']}
    for cookie in cookies:
        print(f"{cookie}: {cookies[cookie]}\n")