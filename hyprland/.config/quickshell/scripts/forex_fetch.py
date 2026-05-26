#!/usr/bin/env python3
"""Fetch USD→MXN exchange rate from frankfurter.app.

Output format:
  FOREX|||19.2345
  FOREX_CHANGE|||+0.42|||up    (up / down / flat; omitted if unavailable)
  FOREX_STATUS|||ok  (or "cached <date>", or "unavailable")
"""

import os
import json
import urllib.request
import urllib.error
from datetime import datetime, timedelta

BASE = "https://api.frankfurter.dev/v1"
URL = f"{BASE}/latest?from=USD&to=MXN"
CACHE_FILE = os.path.expanduser("~/.cache/quickshell/forex.json")


def fmt_rate(rate):
    return f"{rate:.4f}"


def fetch_url(url):
    req = urllib.request.Request(url, headers={"User-Agent": "quickshell-forex/1.0"})
    with urllib.request.urlopen(req, timeout=8) as resp:
        return json.loads(resp.read())


def write_cache(rate, change_pct):
    os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
    data = {"fetched_at": datetime.now().isoformat(timespec="minutes"), "rate": rate}
    if change_pct is not None:
        data["change_pct"] = change_pct
    with open(CACHE_FILE, "w") as f:
        json.dump(data, f)


def read_cache():
    if not os.path.exists(CACHE_FILE):
        return None
    try:
        data = json.loads(open(CACHE_FILE).read())
        return data["rate"], data.get("fetched_at", "unknown"), data.get("change_pct")
    except Exception:
        return None


def emit_change(change_pct):
    direction = "up" if change_pct > 0.005 else "down" if change_pct < -0.005 else "flat"
    print(f"FOREX_CHANGE|||{change_pct:+.2f}|||{direction}", flush=True)


def main():
    try:
        rate = fetch_url(URL)["rates"]["MXN"]

        change_pct = None
        try:
            yesterday = (datetime.now() - timedelta(days=1)).strftime("%Y-%m-%d")
            prev_rate = fetch_url(f"{BASE}/{yesterday}?from=USD&to=MXN")["rates"]["MXN"]
            change_pct = (rate - prev_rate) / prev_rate * 100
        except Exception:
            pass

        write_cache(rate, change_pct)
        print(f"FOREX|||{fmt_rate(rate)}", flush=True)
        if change_pct is not None:
            emit_change(change_pct)
        print("FOREX_STATUS|||ok|||", flush=True)

    except urllib.error.HTTPError as e:
        print(f"FOREX|||HTTP {e.code}|||", flush=True)
        print("FOREX_STATUS|||unavailable|||", flush=True)
    except (urllib.error.URLError, OSError):
        cached = read_cache()
        if cached:
            rate, fetched_at, change_pct = cached
            print(f"FOREX|||{fmt_rate(rate)}", flush=True)
            if change_pct is not None:
                emit_change(change_pct)
            print(f"FOREX_STATUS|||cached|||{fetched_at}", flush=True)
        else:
            print("FOREX|||—|||", flush=True)
            print("FOREX_STATUS|||unavailable|||", flush=True)


if __name__ == "__main__":
    main()
