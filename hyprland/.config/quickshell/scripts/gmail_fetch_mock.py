#!/usr/bin/env python3
import time

EMAILS = [
    ("Project update: Q2 roadmap review", "Sarah Chen <sarah.chen@loomstate.org>"),
    ("Re: Design system tokens — feedback needed", "Alex Rivera <alex.rivera@loomstate.org>"),
    ("Reminder: All-hands meeting tomorrow at 10am", "no-reply@calendar.google.com"),
    ("[JIRA] LM-482 assigned to you: Fix auth token refresh", "jira@JIRA_DOMAIN"),
    ("Your weekly digest is ready", "digest@loomstate.org"),
]

for subject, sender in EMAILS:
    print(f"{subject}|||{sender}", flush=True)
    time.sleep(0.1)
