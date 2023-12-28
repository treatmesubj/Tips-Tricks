#!/usr/bin/env python3
# https://docs.python.org/3/library/urllib.parse.html
import urllib.parse
import argparse
import sys


if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    argparser.add_argument(
        "str",
        nargs="*",
        action="store",
        default=[],
        help="list of strings, strings of text to url-encode",
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

    while len(args.str) > 0:
        decoded_str = args.str.pop(0)
        url_encoded_str = urllib.parse.quote(decoded_str)
        re_decoded_str = urllib.parse.unquote(url_encoded_str)
        assert (
            re_decoded_str == decoded_str
        ), f"Sanity Check Special characters ; , / ? : @ & = + $ - _ . ! ~ * ' ( ) #\n{decoded_str=}\n{url_encoded_str=}"
        print(url_encoded_str)

    while len(args.url) > 0:
        decoded_url = args.url.pop(0)
        components = urllib.parse.urlparse(decoded_url)
        query_dict = urllib.parse.parse_qs(components.query, strict_parsing=True)
        url_encoded_query_str = urllib.parse.urlencode(query_dict, doseq=True)
        components = components._replace(query=url_encoded_query_str)
        encoded_url = components.geturl()
        print(encoded_url)

    while len(args.decode) > 0:
        url_encoded_str = args.decode.pop(0)
        decoded_str = urllib.parse.unquote(url_encoded_str)
        re_url_encoded_str = urllib.parse.quote(decoded_str)
        assert (
            re_url_encoded_str == url_encoded_str
        ), f"Sanity Check Special characters ; , / ? : @ & = + $ - _ . ! ~ * ' ( ) #\n{url_encoded_str=}\n{decoded_str=}"
        print(decoded_str)
