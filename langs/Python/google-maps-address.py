#!/usr/bin/env python3

"""
look up a partial address in Google Maps
to get the full address with zip code etc.
"""

import argparse
import os
import requests
from bs4 import BeautifulSoup

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--address", "-a", action="store")
    args = parser.parse_args()

    # url_encoded_address = os.popen(f"jq -sRr @uri <<< \"{args.address}\"").read().strip()

    html = requests.get(f"https://www.google.com/maps/place/{args.address}").text
    soup = BeautifulSoup(html, "html.parser")
    full_address = soup.select('meta')[1]['content']
    print(full_address)
