#!/usr/bin/env python

import argparse
import os

parser = argparse.ArgumentParser(
    description='Get the folder from path'
)
parser.add_argument(
    '-p',
    '--path',
    required=True,
    help='Path of the file')

args = parser.parse_args()
path = args.path

dir = os.path.dirname(path).strip()
if dir == "":
    dir = "."
    
print(dir)
    