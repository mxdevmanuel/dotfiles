#!/usr/bin/env python3
"""Fetch assigned Jira issues that are In Progress or Selected for Development.

API key from: pass jira/api-token
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

BASE_URL = "https://JIRA_DOMAIN/rest/api/3"
EMAIL = "JIRA_EMAIL"
CACHE_FILE = os.path.expanduser("~/.cache/quickshell/jira-issues.json")
JQL = (
    'assignee = currentUser() '
    'AND status in ("In Progress", "Selected for Development") '
    'ORDER BY priority ASC'
)


def load_api_token() -> str:
    try:
        return subprocess.check_output(["pass", "jira/api-token"], text=True).strip()
    except Exception as e:
        print(f"JIRA|||Error loading token: {e}|||||||", flush=True)
        sys.exit(1)


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


def main():
    token = load_api_token()
    credentials = base64.b64encode(f"{EMAIL}:{token}".encode()).decode()
    req = urllib.request.Request(
        f"{BASE_URL}/search?jql={urllib.request.quote(JQL)}&fields=summary,priority,status&maxResults=10",
        headers={
            "Authorization": f"Basic {credentials}",
            "Accept": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            data = json.loads(resp.read())
        issues = data.get("issues", [])
        write_cache(issues)
        print_issues(issues)
    except (urllib.error.URLError, OSError):
        cached = read_cache()
        if cached:
            issues, fetched_at = cached
            print_issues(issues, cached=True, cached_at=fetched_at)
        else:
            print("JIRA|||Jira unavailable||||||", flush=True)
            print("JIRA_STATUS|||unavailable|||", flush=True)
    except urllib.error.HTTPError as e:
        print(f"JIRA|||HTTP {e.code}: {e.reason}||||||", flush=True)
        print("JIRA_STATUS|||unavailable|||", flush=True)


if __name__ == "__main__":
    main()
