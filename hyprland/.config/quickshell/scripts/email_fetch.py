#!/usr/bin/env python3
"""Fetch unread important Gmail threads from @loomstate.org and summarize with GPT-4o-mini.

Credentials:
  pass openai/api-token
  Google OAuth via ~/.config/google-dashboard-token.json

Output format:
  EMAIL|||subject|||sender|||summary
  EMAIL_STATUS|||ok  (or "unavailable")
"""

import os
import sys
import json
import base64
import subprocess
import re

from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build
from openai import OpenAI

CLIENT_SECRETS = os.path.expanduser("~/.config/google-oauth-client.json")
TOKEN_PATH     = os.path.expanduser("~/.config/google-dashboard-token.json")
CACHE_FILE     = os.path.expanduser("~/.cache/quickshell/email-summaries.json")
SCOPES         = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar.readonly",
]
MAX_THREADS    = 8


def load_openai_key() -> str:
    try:
        return subprocess.check_output(["pass", "openai/api-token"], text=True, timeout=5).strip()
    except Exception as e:
        print(f"EMAIL_STATUS|||unavailable|||{e}", flush=True)
        sys.exit(0)


def get_credentials() -> Credentials:
    creds = None
    if os.path.exists(TOKEN_PATH):
        creds = Credentials.from_authorized_user_file(TOKEN_PATH, SCOPES)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CLIENT_SECRETS, SCOPES)
            creds = flow.run_local_server(port=0)
        with open(TOKEN_PATH, "w") as f:
            f.write(creds.to_json())
    return creds


def load_cache() -> dict:
    if not os.path.exists(CACHE_FILE):
        return {}
    try:
        return json.loads(open(CACHE_FILE).read())
    except Exception:
        return {}


def save_cache(cache: dict) -> None:
    os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
    with open(CACHE_FILE, "w") as f:
        json.dump(cache, f)


def get_header(headers: list[dict], name: str, fallback: str = "") -> str:
    for h in headers:
        if h["name"].lower() == name.lower():
            return h["value"]
    return fallback


def extract_text(payload: dict, depth: int = 0) -> str:
    if depth > 5:
        return ""
    mime = payload.get("mimeType", "")
    body_data = payload.get("body", {}).get("data", "")
    if mime == "text/plain" and body_data:
        try:
            return base64.urlsafe_b64decode(body_data + "==").decode("utf-8", errors="replace")
        except Exception:
            return ""
    for part in payload.get("parts", []):
        text = extract_text(part, depth + 1)
        if text:
            return text
    return ""


def summarize(client: OpenAI, subject: str, thread_text: str) -> str:
    content = f"Subject: {subject}\n\n{thread_text[:4000]}"
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "Summarize this email thread in one concise sentence. Focus on what action or decision is needed, if any."},
            {"role": "user",   "content": content},
        ],
        max_tokens=80,
        temperature=0.3,
    )
    return response.choices[0].message.content.strip()


def safe(value: str) -> str:
    return str(value).replace("|||", " ")


def main():
    api_key = load_openai_key()
    client  = OpenAI(api_key=api_key)
    creds   = get_credentials()
    gmail   = build("gmail", "v1", credentials=creds)
    cache   = load_cache()

    result = gmail.users().threads().list(
        userId="me",
        maxResults=MAX_THREADS,
        q="is:unread is:important from:@loomstate.org",
        fields="threads(id)",
    ).execute()

    threads = result.get("threads", [])
    updated = False

    for t in threads:
        tid = t["id"]

        # Fetch headers only first — cheap, gives us subject/sender for filtering and display
        thread_meta = gmail.users().threads().get(
            userId="me",
            id=tid,
            format="metadata",
            metadataHeaders=["Subject", "From"],
            fields="messages(payload/headers)",
        ).execute()

        messages = thread_meta.get("messages", [])
        if not messages:
            continue

        headers_list = messages[0].get("payload", {}).get("headers", [])
        subject = get_header(headers_list, "subject", "(no subject)")
        sender  = get_header(headers_list, "from", "")

        if "orlandomedina@loomstate.org" in sender and re.search(r"VPO-\d+", subject):
            continue

        if tid in cache:
            print(f"EMAIL|||{safe(subject)}|||{safe(sender)}|||{safe(cache[tid]['summary'])}", flush=True)
            continue

        # Full fetch only for unseen threads
        thread_full = gmail.users().threads().get(
            userId="me",
            id=tid,
            format="full",
            fields="messages(payload)",
        ).execute()

        thread_text = "\n\n---\n\n".join(
            extract_text(m.get("payload", {})) for m in thread_full.get("messages", [])
        ).strip() or subject

        try:
            summary = summarize(client, subject, thread_text)
        except Exception as e:
            summary = f"(error: {e})"

        cache[tid] = {"summary": summary}
        updated = True

        print(f"EMAIL|||{safe(subject)}|||{safe(sender)}|||{safe(summary)}", flush=True)

    if updated:
        save_cache(cache)

    print("EMAIL_STATUS|||ok|||", flush=True)


if __name__ == "__main__":
    main()
