"""
adapted from https://gist.github.com/denis-bz/88611952815b56b5b8b5
    & https://gist.github.com/Tblue/62ff47bef7f894e92ed5
"""

import os
import json
import lz4.block
from pathlib import Path


def get_firefox_cookies(home):
    """
    adapted from https://gist.github.com/denis-bz/88611952815b56b5b8b5
        & https://gist.github.com/Tblue/62ff47bef7f894e92ed5
    """
    def decompress(file_obj):
        if file_obj.read(8) != b"mozLz40\0":
            raise ValueError("Invalid magic number")

        return lz4.block.decompress(file_obj.read())

    firefox_dir = Path(os.path.expanduser(home), 'AppData', 'Roaming', 'Mozilla', 'FireFox', 'Profiles')
    prof_dir = next(firefox_dir.glob("*.default-release"))
    sess_cookies_json_file = Path(prof_dir, 'sessionstore-backups', 'recovery.jsonlz4')

    with open(sess_cookies_json_file, mode='rb') as file:
        sanjay = json.loads(decompress(file))

    cookies = {cookie['name']: {'host': cookie['host'], 'value': cookie['value']} for cookie in sanjay['cookies']}
    return cookies


if __name__ == "__main__":
    # home = '~'
    home = "/mnt/c/Users/JohnHupperts"
    cookies = get_firefox_cookies(home)
    cookies_header_val = ''.join(f"{c}={cookies[c]['value']}; " for c in cookies.keys())
    print(cookies_header_val)

