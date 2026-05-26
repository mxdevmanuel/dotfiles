#!/usr/bin/env python3
import time

SERVERS = [
    ("server-one.lan", "up"),
    ("server-two.lan", "up"),
    ("pi-one.lan", "up"),
    ("pi-two.lan", "down"),
]

for host, status in SERVERS:
    print(f"SERVER|||{host}|||{status}", flush=True)
    time.sleep(0.05)

print("SERVER_STATUS|||ok|||", flush=True)
