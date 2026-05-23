#!/usr/bin/env python3
import time

TASKS = [
    ("TODO", "Review PR #47 — auth middleware refactor", "Platform"),
    ("TODO", "Write release notes for v2.3.0", "Platform"),
    ("TODO", "Follow up with Sarah on design tokens", "Design System"),
    ("TODO", "Update staging environment config", "Infra"),
    ("TODO", "Read chapter 4 of Designing Data-Intensive Apps", ""),
]

for row in TASKS:
    print("|||".join(row), flush=True)
    time.sleep(0.05)
