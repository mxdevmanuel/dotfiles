#!/usr/bin/env python3
"""Fetch assigned Jira issues that are In Progress or Selected for Development.

Credentials from pass:
  pass jira/api-token
  pass jira/email
Output format:
  JIRA|||KEY-123|||summary|||priority|||status
  JIRA_STATUS|||ok  (or "cached <date>", or "unavailable")
"""

import os
import sys
import json
import base64
import subprocess
import urllib.request
import urllib.error
from datetime import datetime

LOG_FILE = os.path.expanduser("~/.cache/quickshell/jira_fetch.log")


def log(msg):
    ts = datetime.now().strftime("%H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line, file=sys.stderr, flush=True)
    try:
        os.makedirs(os.path.dirname(LOG_FILE), exist_ok=True)
        with open(LOG_FILE, "a") as f:
            f.write(line + "\n")
    except Exception:
        pass

BASE_URL = "https://JIRA_DOMAIN/rest/api/3"
CACHE_FILE = os.path.expanduser("~/.cache/quickshell/jira-issues.json")
JQL = (
    'assignee = currentUser() '
    'AND status in ("In Progress", "Selected for Development") '
    'ORDER BY priority ASC'
)


def load_api_token() -> str:
    log("loading token via pass...")
    try:
        token = subprocess.check_output(["pass", "jira/api-token"], text=True, timeout=5).strip()
        log("token loaded ok")
        return token
    except subprocess.TimeoutExpired:
        log("ERROR: pass timed out after 5s")
        cached = read_cache()
        if cached:
            log("falling back to cache")
            print_issues(cached[0], cached=True, cached_at=cached[1])
        else:
            print("JIRA_STATUS|||unavailable|||pass timed out", flush=True)
        sys.exit(0)
    except Exception as e:
        log(f"ERROR loading token: {e}")
        cached = read_cache()
        if cached:
            log("falling back to cache")
            print_issues(cached[0], cached=True, cached_at=cached[1])
        else:
            print(f"JIRA_STATUS|||unavailable|||{e}", flush=True)
        sys.exit(0)


def safe(value: str) -> str:
    return str(value).replace("|||", " ")


def print_issues(issues: list, cached: bool = False, cached_at: str = "") -> None:
    for issue in issues:
        key = safe(issue.get("key", ""))
        fields = issue.get("fields", {})
        summary = safe(fields.get("summary", "(no summary)"))
        priority = safe((fields.get("priority") or {}).get("name", "Medium"))
        status = safe((fields.get("status") or {}).get("name", ""))
        print(f"JIRA|||{key}|||{summary}|||{priority}|||{status}", flush=True)
    if cached:
        print(f"JIRA_STATUS|||cached|||{cached_at}", flush=True)
    else:
        print("JIRA_STATUS|||ok|||", flush=True)


def write_cache(issues: list) -> None:
    os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
    with open(CACHE_FILE, "w") as f:
        json.dump({"fetched_at": datetime.now().isoformat(timespec="minutes"), "issues": issues}, f)


def read_cache() -> tuple[list, str] | None:
    if not os.path.exists(CACHE_FILE):
        return None
    try:
        data = json.loads(open(CACHE_FILE).read())
        return data["issues"], data.get("fetched_at", "unknown")
    except Exception:
        return None


def load_email() -> str:
    try:
        return subprocess.check_output(["pass", "jira/email"], text=True, timeout=5).strip()
    except Exception as e:
        log(f"ERROR loading email: {e}")
        print(f"JIRA_STATUS|||unavailable|||{e}", flush=True)
        sys.exit(0)


def main():
    log(f"--- jira_fetch start (pid {os.getpid()}) ---")
    token = load_api_token()
    email = load_email()
    credentials = base64.b64encode(f"{email}:{token}".encode()).decode()
    url = f"{BASE_URL}/search/jql"
    log(f"requesting {url}")
    body = json.dumps({"jql": JQL, "fields": ["summary", "priority", "status"], "maxResults": 10}).encode()
    log(f"jql: {JQL}")
    req = urllib.request.Request(url, data=body, headers={
        "Authorization": f"Basic {credentials}",
        "Content-Type": "application/json",
        "Accept": "application/json",
    })
    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            raw = resp.read()
        data = json.loads(raw)
        log(f"response keys: {list(data.keys())}")
        log(f"raw (first 500): {raw[:500]}")
        issues = data.get("issues", [])
        log(f"got {len(issues)} issue(s)")
        write_cache(issues)
        print_issues(issues)
    except urllib.error.HTTPError as e:
        log(f"HTTP error {e.code}: {e.reason}")
        print(f"JIRA_STATUS|||unavailable|||HTTP {e.code}", flush=True)
    except (urllib.error.URLError, OSError) as e:
        log(f"network error: {e}")
        cached = read_cache()
        if cached:
            issues, fetched_at = cached
            log(f"using cache from {fetched_at}")
            print_issues(issues, cached=True, cached_at=fetched_at)
        else:
            log("no cache available")
            print("JIRA_STATUS|||unavailable|||", flush=True)


if __name__ == "__main__":
    main()
