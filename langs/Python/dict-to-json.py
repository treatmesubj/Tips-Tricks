#!/usr/bin/env python3
import argparse
import sys
import json  # https://docs.python.org/3/library/json.html

# valid JSON requires double quotes
# python read from stdin example


parser = argparse.ArgumentParser()
parser.add_argument("infile", default=sys.stdin, type=argparse.FileType("r"), nargs="?")
args = parser.parse_args()

data = args.infile.read()
data_dict = eval(data)

print(json.dumps(data_dict, indent=4))

# strings
# sanjay = json.loads(stringy)
# print(json.dumps(sanjay, indent=4, sort_keys=False))
