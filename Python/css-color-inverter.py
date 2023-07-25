#!/usr/bin/env python

# Concept taken from http://code.activestate.com/recipes/527747-invert-css-hex-colors/
# Modified to take the css filename as an argument and also handle rgb() and rgba() values
#
# To run:
#     python ./colour-inverter.py <path/to/file.css>

import os
import re
import sys

if not (len(sys.argv) > 1 and os.path.isfile(sys.argv[1])):
    print('You must specify a css file to invert')
    sys.exit(1)

re_hex = re.compile("#([0-9a-f]{3,6})(\W)?", re.IGNORECASE)
re_rgb = re.compile("(rgba?)\( ?(\d{1,3}), ?(\d{1,3}), ?(\d{1,3}) ?(, [\d\.]{1,})?\)", re.IGNORECASE)

def invert_hex(content):
    text = content.group(1).lower()
    code = {}
    l1="0123456789abcdef"
    l2="fedcba9876543210"
    for i in range(len(l1)):
        code[l1[i]]=l2[i]
    inverted = ""
    for j in text:
        inverted += code[j]
    return f'#{inverted}{content.group(2)}'

def invert_rgb(content):
    rgb = content.group(1)
    num1 = 255 - int(content.group(2))
    num2 = 255 - int(content.group(3))
    num3 = 255 - int(content.group(4))
    alpha = content.group(5)
    return f'{rgb}({num1}, {num2}, {num3}{alpha})'

inputfile = sys.argv[1]

with open(inputfile,'r') as file:
    content = file.read()
    print('Converting 6 digit hex...')
    content = re_hex.sub(invert_hex, content)
    print('Converting rgb...')
    content = re_rgb.sub(invert_rgb, content)

with open(inputfile[:-4]+"-inverted.css", 'w') as file:
    file.write(content)

