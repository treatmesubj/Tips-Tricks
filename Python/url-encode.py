#!/usr/bin/env python3
# https://docs.python.org/3/library/urllib.parse.html
import sys
import urllib.parse
import argparse
from rich import pretty, print; pretty.install()


def url_encode_str(notencoded_str):
    urlencoded_str = urllib.parse.quote(notencoded_str)
    assert urllib.parse.unquote(urlencoded_str) == notencoded_str
    return urlencoded_str

if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    group = argparser.add_mutually_exclusive_group(required=False)
    group.add_argument(
        "--str",
        "-s",
        action="store",
        default=None,
        help="string, string of text to url-encode",
    )
    group.add_argument(
        "--url",
        "-u",
        action="store",
        default=None,
        help="string, plain human-readable un-encoded URL",
    )
    argparser.add_argument(
        'pos_strs',  # if too lazy to type '-s' arg
        nargs='*',
        default=None,
        help="list of strings, strings of text to url-encode",
    )
    args = argparser.parse_args()

    if args.url:
        components = urllib.parse.urlparse(args.url)
        query_dict = urllib.parse.parse_qs(components.query)
        urlencoded_query_str = urllib.parse.urlencode(query_dict, doseq=True)
        components = components._replace(query=urlencoded_query_str)
        encoded_url = components.geturl()
        print(encoded_url)
    else:  # strings
        if not args.str and args.pos_strs:
            while len(args.pos_strs) > 0:
                notencoded_str = args.pos_strs.pop(0)
                print(url_encode_str(notencoded_str))
        else:
            notencoded_str = args.str
            print(url_encode_str(notencoded_str))

    # https://gre.tririga.com/oslc/spq/cstSpaceQC?oslc.select=*,spi:cstParentFloorLRS{spi:triIdTX,spi:cstParentBuildingLRS{spi:triIdTX,spi:cstParentPropertyLRS{spi:triIdTX}}}
