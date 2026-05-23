#!/usr/bin/env python3
"""Fetch the top 5 most relevant Gmail inbox messages and print their subjects."""

import os
import sys

from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build

CLIENT_SECRETS = os.path.expanduser("~/.config/google-oauth-client.json")
TOKEN_PATH = os.path.expanduser("~/.config/google-gmail-token.json")
SCOPES = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar.readonly",
]
MAX_RESULTS = 5


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


def main():
    creds = get_credentials()
    service = build("gmail", "v1", credentials=creds)

    result = service.users().messages().list(
        userId="me",
        maxResults=MAX_RESULTS,
        labelIds=["INBOX"],
        q="is:unread",
    ).execute()

    messages = result.get("messages", [])
    if not messages:
        print("No unread messages found.")
        return

    for msg_ref in messages:
        msg = service.users().messages().get(
            userId="me",
            id=msg_ref["id"],
            format="metadata",
            metadataHeaders=["Subject", "From"],
        ).execute()
        headers = msg["payload"]["headers"]
        subject = get_header(headers, "subject", "(no subject)").replace("|||", " ")
        sender = get_header(headers, "from", "(unknown)").replace("|||", " ")
        print(f"{subject}|||{sender}", flush=True)


if __name__ == "__main__":
    main()
