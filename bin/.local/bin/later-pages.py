#!/usr/bin/python3

import argparse
from yaml import load, dump
try:
        from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
        from yaml import Loader, Dumper


def add():
    print("add")

def remove():
    print("remove")

operations = {
    "add": add,
    "remove": remove
}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("operation")

    args = parser.parse_args()

    operations[args.operation]()

if __name__ == "__main__":
    main()
