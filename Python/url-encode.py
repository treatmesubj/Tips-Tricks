#!/usr/bin/env python3
# https://docs.python.org/3/library/urllib.parse.html
import urllib.parse
import re
import argparse
import sys


def lowercase_url_encode(url_encoded_str):
    reggy = re.compile(r"%[0-9A-Z]{2}")
    low_url_enc_str = reggy.sub(
        lambda matchobj: matchobj.group(0).lower(), url_encoded_str
    )
    return low_url_enc_str


if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    argparser.add_argument(
        "str",
        nargs="*",
        action="store",
        default=[],
        help="list of strings, strings of text to url-encode. Letters, digits, & characters '_.-~' aren't encoded. Spaces are encoded as '+'.",
    )
    argparser.add_argument(
        "--url",
        "-u",
        nargs="*",
        action="store",
        default=[],
        help="list of strings, plain human-readable URLs to url-encode",
    )
    argparser.add_argument(
        "--decode",
        "-d",
        nargs="*",
        action="store",
        default=[],
        help="list of strings, url-encoded strings to decode",
    )
    args = argparser.parse_args()

    if not len(sys.argv) > 1:
        argparser.print_help()
    print("\n", end="")

    # URL-encode strings
    while len(args.str) > 0:
        decoded_str = args.str.pop(0)
        url_encoded_str = lowercase_url_encode(
            urllib.parse.quote_plus(decoded_str, safe="/_.-~")
        )
        re_decoded_str = urllib.parse.unquote_plus(url_encoded_str)
        assert (
            re_decoded_str == decoded_str
        ), f"Check Special Characters ; , / ? : @ & = + $ - _ . ! ~ * ' ( ) #\n\n{decoded_str=}\n{url_encoded_str=}\n{re_decoded_str=}"
        print(url_encoded_str)

    # URL-encode URLs
    while len(args.url) > 0:
        decoded_url = args.url.pop(0)
        components = urllib.parse.urlparse(decoded_url)

        # encode netloc
        url_encoded_netloc = lowercase_url_encode(
            urllib.parse.quote(components.netloc, safe="_.-~")
        )
        components = components._replace(netloc=url_encoded_netloc)
        # encode path
        url_encoded_path = lowercase_url_encode(
            urllib.parse.quote(components.path, safe="/_.-~")
        )
        components = components._replace(path=url_encoded_path)
        # encode query
        query_dict = urllib.parse.parse_qs(components.query, strict_parsing=True)
        url_encoded_query_str = lowercase_url_encode(
            urllib.parse.urlencode(query_dict, doseq=True)
        )
        components = components._replace(query=url_encoded_query_str)

        url_encoded_url = components.geturl()
        re_decoded_url = urllib.parse.unquote(url_encoded_url)
        assert (
            re_decoded_url == decoded_url
        ), f"Check Special Characters ; , / ? : @ & = + $ - _ . ! ~ * ' ( ) #\n\n{decoded_url=}\n{url_encoded_url=}\n{re_decoded_url=}"
        print(url_encoded_url)

    # URL-decode strings
    while len(args.decode) > 0:
        url_encoded_str = lowercase_url_encode(args.decode.pop(0))
        # components = urllib.parse.urlparse(url_encoded_str)
        decoded_str = urllib.parse.unquote_plus(url_encoded_str)
        re_url_encoded_str = lowercase_url_encode(
            urllib.parse.quote_plus(decoded_str, safe="/_.-~")
        )
        redecoded_str = urllib.parse.unquote_plus(re_url_encoded_str)
        assert (
            redecoded_str == decoded_str
        ), f"Check Special Characters ; , / ? : @ & = + $ - _ . ! ~ * ' ( ) #\n\n{url_encoded_str=}\n{decoded_str=}\n{re_url_encoded_str=}"
        print(decoded_str)
