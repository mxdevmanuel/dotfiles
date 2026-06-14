#!/usr/bin/env python3
"""Add an item to the Tududi inbox.

Output (one line):
  OK|||<content>
  ERROR|||<message>
"""

import sys
import json
import subprocess
import urllib.request
import urllib.error

BASE_URL = "https://tududi.morarosa.xyz/api/v1"


def load_api_key() -> str:
    return subprocess.check_output(["pass", "tududi/api-key"], text=True).strip()


def main():
    if len(sys.argv) < 2:
        print("ERROR|||Usage: tududi_add.py <content>", flush=True)
        sys.exit(1)

    content = " ".join(sys.argv[1:])
    api_key = load_api_key()

    payload = json.dumps({"content": content, "source": "manual"}).encode()
    req = urllib.request.Request(
        f"{BASE_URL}/inbox",
        data=payload,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            data = json.loads(resp.read())
        print(f"OK|||{data.get('content', content)}", flush=True)
    except urllib.error.HTTPError as e:
        print(f"ERROR|||HTTP {e.code}: {e.reason}", flush=True)
        sys.exit(1)
    except (urllib.error.URLError, OSError) as e:
        print(f"ERROR|||{e}", flush=True)
        sys.exit(1)


if __name__ == "__main__":
    main()
