#!/usr/bin/env python3
"""Fetch today's Tududi tasks, with a local cache fallback when offline/VPN down.

Output format (one line per task, flushed immediately):
  TODO|||name|||project
  TODO_STATUS|||ok   (or "cached <date>", or "unavailable")
"""

import os
import sys
import json
import subprocess
import urllib.request
import urllib.error
from datetime import datetime

BASE_URL = "https://tududi.morarosa.xyz/api/v1"
CACHE_FILE = os.path.expanduser("~/.cache/quickshell/tududi-tasks.json")


def load_api_key() -> str:
    try:
        return subprocess.check_output(["pass", "tududi/api-key"], text=True).strip()
    except Exception as e:
        print(f"TODO|||Error loading API key: {e}|||", flush=True)
        sys.exit(1)


def safe(value: str) -> str:
    return value.replace("|||", " ")


def print_tasks(tasks: list, cached: bool = False, cached_at: str = "") -> None:
    for task in tasks:
        name = safe(task.get("name", "(unnamed)"))
        project = safe((task.get("project") or {}).get("name", ""))
        print(f"TODO|||{name}|||{project}", flush=True)
    if cached:
        print(f"TODO_STATUS|||cached|||{cached_at}", flush=True)
    else:
        print("TODO_STATUS|||ok|||", flush=True)


def write_cache(tasks: list) -> None:
    os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
    with open(CACHE_FILE, "w") as f:
        json.dump({"fetched_at": datetime.now().isoformat(timespec="minutes"), "tasks": tasks}, f)


def read_cache() -> tuple[list, str] | None:
    if not os.path.exists(CACHE_FILE):
        return None
    try:
        data = json.loads(open(CACHE_FILE).read())
        return data["tasks"], data.get("fetched_at", "unknown")
    except Exception:
        return None


def main():
    api_key = load_api_key()
    req = urllib.request.Request(
        f"{BASE_URL}/tasks?type=today&status=active",
        headers={"Authorization": f"Bearer {api_key}", "Accept": "application/json"},
    )
    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            data = json.loads(resp.read())
        tasks = data.get("tasks", data) if isinstance(data, dict) else data
        write_cache(tasks)
        print_tasks(tasks)
    except (urllib.error.URLError, OSError):
        cached = read_cache()
        if cached:
            tasks, fetched_at = cached
            print_tasks(tasks, cached=True, cached_at=fetched_at)
        else:
            print("TODO|||Tududi unavailable|||", flush=True)
            print("TODO_STATUS|||unavailable|||", flush=True)
    except urllib.error.HTTPError as e:
        print(f"TODO|||HTTP {e.code}: {e.reason}|||", flush=True)
        print("TODO_STATUS|||unavailable|||", flush=True)


if __name__ == "__main__":
    main()
