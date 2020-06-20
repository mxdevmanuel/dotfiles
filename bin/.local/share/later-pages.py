import argparse
import json
import os
import sys
import requests
from datetime import datetime, timedelta
from bs4 import BeautifulSoup
from uuid import uuid1

file = os.path.expandvars("$HOME/.lines/later-pages.json")

def load_file():
    with open(file, 'r+') as f:
        return json.load(f)

def save_file(data):
    with open(file, 'w') as f:
        json.dump(data, f)

def get_title(url):
    page = requests.get(url)
    soup = BeautifulSoup(page.text, "html.parser")
    return soup.title.string


def generate(url):
    title = get_title(url)
    entry  =  {
        "id": uuid1().hex[:7],
        "url": url,
        "title": title[:50],
        "expire": ( datetime.now().date() + timedelta(weeks=1) ).__str__()
    }
    return entry


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("operation", choices=["add", "list", "remove"])
    parser.add_argument("url", nargs="?")
    parser.add_argument("--id")

    args = parser.parse_args()

    if args.operation != "list" and not ( args.url or args.id):
        print("No url or id provided", file=sys.stderr)
        sys.exit(1)

    data = []
    try:
        data = load_file()
    except FileNotFoundError:
        pass


    if args.operation == "add":
        try:
            entry = generate(args.url)
            data.append(entry)
        except requests.RequestException as err:
            print("Network error {}".format(str(err)), file=sys.stderr)

    if args.operation == "list":
        for entry in data:
            print("{} {}".format(entry['id'],entry['title']))

    if args.operation == "remove":
        if args.url:
            data = filter(lambda x: x["url"] != args.url, data)
        elif args.id:
            data = filter(lambda x: x["id"] != args.id, data)
        else:
            print("Something is not working on initial check", file=sys.stderr)
        data = [ x for x in data ]

    save_file(data)


if __name__ == "__main__":
    main()
