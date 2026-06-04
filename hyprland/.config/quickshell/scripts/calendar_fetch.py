#!/usr/bin/env python3
"""Fetch today's Google Calendar events.

Credentials:
  Google OAuth via ~/.config/google-dashboard-token.json (shared with email_fetch)

Output format:
  CAL|||HH:MM|||title|||location
"""

import os
from datetime import datetime, timezone, timedelta

from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

CLIENT_SECRETS = os.path.expanduser("~/.config/google-oauth-client.json")
TOKEN_PATH     = os.path.expanduser("~/.config/google-dashboard-token.json")
SCOPES         = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar.readonly",
]
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


def safe(value: str) -> str:
    return str(value).replace("|||", " ")


def main():
    creds    = get_credentials()
    calendar = build("calendar", "v3", credentials=creds)

    now   = datetime.now(timezone.utc)
    start = now.replace(hour=0, minute=0, second=0, microsecond=0).isoformat()
    end   = (now.replace(hour=0, minute=0, second=0, microsecond=0) + timedelta(days=1)).isoformat()

    result = calendar.events().list(
        calendarId="primary",
        timeMin=start,
        timeMax=end,
        maxResults=MAX_EVENTS,
        singleEvents=True,
        orderBy="startTime",
    ).execute()

    for event in result.get("items", []):
        if event.get("eventType") == "workingLocation":
            continue
        start_info = event.get("start", {})
        if "dateTime" in start_info:
            dt = datetime.fromisoformat(start_info["dateTime"])
            time_str = dt.strftime("%H:%M")
        else:
            time_str = "all-day"

        title    = safe(event.get("summary", "(no title)"))
        location = safe(event.get("location", ""))
        print(f"CAL|||{time_str}|||{title}|||{location}", flush=True)


if __name__ == "__main__":
    main()
