#!/usr/bin/env python3
import time

EMAILS = [
    ("EMAIL", "Project update: Q2 roadmap review", "Sarah Chen <sarah.chen@loomstate.org>"),
    ("EMAIL", "Re: Design system tokens — feedback needed", "Alex Rivera <alex.rivera@loomstate.org>"),
    ("EMAIL", "Reminder: All-hands meeting tomorrow at 10am", "no-reply@calendar.google.com"),
    ("EMAIL", "[JIRA] LM-482 assigned to you: Fix auth token refresh", "jira@JIRA_DOMAIN"),
    ("EMAIL", "Your weekly digest is ready", "digest@loomstate.org"),
]

EVENTS = [
    ("CAL", "09:00", "Standup", ""),
    ("CAL", "10:30", "Q2 Roadmap Review", "Conf Room B"),
    ("CAL", "12:00", "Lunch with Alex", ""),
    ("CAL", "14:00", "1:1 with Sarah", "Google Meet"),
    ("CAL", "16:30", "Design System Sync", "Conf Room A"),
]

for row in EMAILS:
    print("|||".join(row), flush=True)
    time.sleep(0.05)

for row in EVENTS:
    print("|||".join(row), flush=True)
    time.sleep(0.05)
