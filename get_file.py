#!/usr/bin/env python

import argparse
import os

parser = argparse.ArgumentParser(
    description='Get the filename without extension from path'
)
parser.add_argument(
    '-p',
    '--path',
    required=True,
    help='Path of the file')

parser.add_argument('--stripext', action=argparse.BooleanOptionalAction)

args = parser.parse_args()
path = args.path
stripext = args.stripext

# file name with extension
file_name = os.path.basename(path).strip()

if stripext:
    # file name without extension
    print(os.path.splitext(file_name)[0])
else:
    print(file_name)