#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
clips_dir="${repo_root}/Documentation/Assets/AppDemoClips"
policy_file="${repo_root}/Documentation/app-media-policy.json"

[[ -d "$clips_dir" ]] || { echo "Missing demo clip directory: $clips_dir" >&2; exit 1; }
[[ -f "$policy_file" ]] || { echo "Missing media policy: $policy_file" >&2; exit 1; }

python3 - "${repo_root}" "${policy_file}" "${clips_dir}" <<'PY'
import json
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])
policy_path = Path(sys.argv[2])
clips_dir = Path(sys.argv[3])

policy = json.loads(policy_path.read_text())
router = (repo_root / "Documentation" / "App-Media" / "README.md").read_text()
gallery = (repo_root / "Documentation" / "App-Gallery.md").read_text()

for item in policy["apps"]:
    app_id = item["id"]
    clip_path = clips_dir / f"{app_id}.mp4"
    media_page = (repo_root / item["required_readme"]).read_text()
    has_clip = clip_path.exists()
    expected_status = item["status"] if has_clip else "screenshot-published"

    if item["status"] != expected_status:
        raise SystemExit(f"Unexpected media status for {app_id}: {item['status']} (expected {expected_status})")

    if f"| {app_id} | {item['lane']} | `{expected_status}` |" not in router:
        raise SystemExit(f"Media router missing {app_id} status {expected_status}")

    if f"Media status: `{expected_status}`" not in media_page:
        raise SystemExit(f"Media page missing status {expected_status} for {app_id}")

    if has_clip:
        relative_clip = f"../Assets/AppDemoClips/{app_id}.mp4"
        if relative_clip not in media_page:
            raise SystemExit(f"Media page missing clip link for {app_id}")
        if f"./Assets/AppDemoClips/{app_id}.mp4" not in gallery:
            raise SystemExit(f"Gallery missing clip link for {app_id}")
    else:
        if "demo clip is not yet published" not in media_page:
            raise SystemExit(f"Media page must keep clip gap visible for {app_id}")

print("App demo clips validation passed.")
PY
