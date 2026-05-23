#!/usr/bin/env python3
"""Fetch Gmail inbox and today's Google Calendar events. Authenticates once.

Output format (one line per item, flushed immediately):
  EMAIL|||subject|||sender
  CAL|||HH:MM|||title|||location
"""

import os
import sys
from datetime import datetime, timezone, timedelta

from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

CLIENT_SECRETS = os.path.expanduser("~/.config/google-oauth-client.json")
TOKEN_PATH = os.path.expanduser("~/.config/google-dashboard-token.json")
SCOPES = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar.readonly",
]
MAX_EMAILS = 5
MAX_EVENTS = 8


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


def get_header(headers: list[dict], name: str, fallback: str = "") -> str:
    for h in headers:
        if h["name"].lower() == name.lower():
            return h["value"]
    return fallback


def safe(value: str) -> str:
    return value.replace("|||", " ")


def fetch_emails(service) -> None:
    result = service.users().messages().list(
        userId="me",
        maxResults=MAX_EMAILS,
        labelIds=["INBOX"],
        q="is:unread",
    ).execute()

    for msg_ref in result.get("messages", []):
        msg = service.users().messages().get(
            userId="me",
            id=msg_ref["id"],
            format="metadata",
            metadataHeaders=["Subject", "From"],
        ).execute()
        headers = msg["payload"]["headers"]
        subject = safe(get_header(headers, "subject", "(no subject)"))
        sender = safe(get_header(headers, "from", "(unknown)"))
        print(f"EMAIL|||{subject}|||{sender}", flush=True)


def fetch_calendar(service) -> None:
    now = datetime.now(timezone.utc)
    start = now.replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
    end = (now.replace(hour=0, minute=0, second=0, microsecond=0) + timedelta(days=1)).isoformat()

    result = service.events().list(
        calendarId="primary",
        timeMin=start,
        timeMax=end,
        maxResults=MAX_EVENTS,
        singleEvents=True,
        orderBy="startTime",
    ).execute()

    for event in result.get("items", []):
        start_info = event.get("start", {})
        if "dateTime" in start_info:
            dt = datetime.fromisoformat(start_info["dateTime"])
            time_str = dt.strftime("%H:%M")
        else:
            time_str = "all-day"

        title = safe(event.get("summary", "(no title)"))
        location = safe(event.get("location", ""))
        print(f"CAL|||{time_str}|||{title}|||{location}", flush=True)


def main():
    creds = get_credentials()
    gmail = build("gmail", "v1", credentials=creds)
    calendar = build("calendar", "v3", credentials=creds)
    fetch_emails(gmail)
    fetch_calendar(calendar)


if __name__ == "__main__":
    main()
