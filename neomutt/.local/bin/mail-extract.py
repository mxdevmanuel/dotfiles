#!/usr/bin/env python3

"""A simple python script template.

"""

import email
import json
import sys
import argparse


def main(arguments):

    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('infile', help="Input file", type=argparse.FileType('r'))

    args = parser.parse_args(arguments)

    message = email.message_from_file(args.infile)

    fields = ["from", "to", "subject"]

    output = {}

    for field in fields:
        output[field] = message[field]

    print(json.dumps(output))

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
