#!/usr/bin/env python3
import argparse
import sys
from bs4 import BeautifulSoup
from rich.console import Console
from rich.syntax import Syntax

"""
curl -s google.com | ./css-select.py - 'head'
"""


parser = argparse.ArgumentParser()
parser.add_argument(
    "infile",
    default=sys.stdin,
    type=argparse.FileType("r"),
    nargs="?",
    help="file or - (for stdin)",
)
parser.add_argument("cssselector", action="store", nargs="?")
args = parser.parse_args()

soup = BeautifulSoup(args.infile, "html.parser")

console = Console()
if args.cssselector:
    for i, html in enumerate(soup.select(args.cssselector)):
        print(i)
        console.print(Syntax(html.prettify(), "html"))
else:
    console.print(Syntax(soup.prettify(), "html"))
