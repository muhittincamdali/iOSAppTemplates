#!/usr/bin/env python3

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: validate-github-distribution-policy.py <policy-path>", file=sys.stderr)
        return 1

    path = Path(sys.argv[1])
    payload = json.loads(path.read_text())

    required_keys = {"description", "homepage", "topics"}
    missing = required_keys.difference(payload)
    if missing:
        print(f"Missing policy keys: {sorted(missing)}", file=sys.stderr)
        return 1

    topics = payload["topics"]
    if not isinstance(topics, list) or len(topics) < 5:
        print("Policy must define at least 5 GitHub topics.", file=sys.stderr)
        return 1

    if len(set(topics)) != len(topics):
        print("Policy topics must be unique.", file=sys.stderr)
        return 1

    if "GLOBAL_AI_STANDARDS" in payload["description"] or "100%" in payload["description"]:
        print("Description contains hype or stale compliance language.", file=sys.stderr)
        return 1

    print("GitHub distribution policy validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
