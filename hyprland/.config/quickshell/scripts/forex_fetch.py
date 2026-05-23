#!/usr/bin/env python3
"""Fetch USD→MXN exchange rate from frankfurter.app.

Output format:
  FOREX|||19.2345
  FOREX_STATUS|||ok  (or "cached <date>", or "unavailable")
"""

import os
import json
import urllib.request
import urllib.error
from datetime import datetime

URL = "https://api.frankfurter.app/latest?from=USD&to=MXN"
CACHE_FILE = os.path.expanduser("~/.cache/quickshell/forex.json")


def fmt_rate(rate: float) -> str:
    return f"{rate:.4f}"


def write_cache(rate: float) -> None:
    os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
    with open(CACHE_FILE, "w") as f:
        json.dump({"fetched_at": datetime.now().isoformat(timespec="minutes"), "rate": rate}, f)


def read_cache():
    if not os.path.exists(CACHE_FILE):
        return None
    try:
        data = json.loads(open(CACHE_FILE).read())
        return data["rate"], data.get("fetched_at", "unknown")
    except Exception:
        return None


def main():
    try:
        with urllib.request.urlopen(URL, timeout=8) as resp:
            data = json.loads(resp.read())
        rate = data["rates"]["MXN"]
        write_cache(rate)
        print(f"FOREX|||{fmt_rate(rate)}", flush=True)
        print("FOREX_STATUS|||ok|||", flush=True)
    except (urllib.error.URLError, OSError):
        cached = read_cache()
        if cached:
            rate, fetched_at = cached
            print(f"FOREX|||{fmt_rate(rate)}", flush=True)
            print(f"FOREX_STATUS|||cached|||{fetched_at}", flush=True)
        else:
            print("FOREX|||—|||", flush=True)
            print("FOREX_STATUS|||unavailable|||", flush=True)
    except urllib.error.HTTPError as e:
        print(f"FOREX|||HTTP {e.code}|||", flush=True)
        print("FOREX_STATUS|||unavailable|||", flush=True)


if __name__ == "__main__":
    main()
