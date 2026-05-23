#!/usr/bin/env python3
import time

ISSUES = [
    ("JIRA", "LM-482", "Fix auth token refresh race condition on mobile", "Highest", "In Progress"),
    ("JIRA", "LM-471", "Migrate legacy REST endpoints to GraphQL", "High", "In Progress"),
    ("JIRA", "LM-495", "Add pagination to /api/v1/tasks endpoint", "High", "Selected for Development"),
    ("JIRA", "LM-501", "Update Node.js to v22 LTS across all services", "Medium", "Selected for Development"),
]

for row in ISSUES:
    print("|||".join(row), flush=True)
    time.sleep(0.05)

print("JIRA_STATUS|||ok|||", flush=True)
