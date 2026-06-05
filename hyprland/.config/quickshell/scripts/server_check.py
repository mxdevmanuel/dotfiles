#!/usr/bin/env python3
"""Ping homelab hosts in parallel and report reachability.

Output format:
  SERVER|||hostname|||up
  SERVER|||hostname|||down
  SERVER_STATUS|||ok|||
"""

import subprocess
import threading

HOSTS = ["server-one.lan", "server-two.lan", "pi-one.lan", "pi-two.lan", "pi-three.lan"]

lock = threading.Lock()


def check(host):
    try:
        r = subprocess.run(
            ["ping", "-c", "1", "-W", "1", host],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=3,
        )
        status = "up" if r.returncode == 0 else "down"
    except Exception:
        status = "down"
    with lock:
        print(f"SERVER|||{host}|||{status}", flush=True)


threads = [threading.Thread(target=check, args=(h,)) for h in HOSTS]
for t in threads:
    t.start()
for t in threads:
    t.join()

print("SERVER_STATUS|||ok|||", flush=True)
