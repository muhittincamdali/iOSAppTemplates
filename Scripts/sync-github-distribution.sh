#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

policy_file="Documentation/github-distribution-policy.json"
python3 Scripts/validate-github-distribution-policy.py "$policy_file" >/dev/null

description="$(python3 - <<'PY'
import json
from pathlib import Path
payload = json.loads(Path("Documentation/github-distribution-policy.json").read_text())
print(payload["description"])
PY
)"

homepage="$(python3 - <<'PY'
import json
from pathlib import Path
payload = json.loads(Path("Documentation/github-distribution-policy.json").read_text())
print(payload["homepage"])
PY
)"

gh api --method PATCH repos/muhittincamdali/iOSAppTemplates \
  -f description="$description" \
  -f homepage="$homepage" >/dev/null

python3 - <<'PY' | gh api --method PUT repos/muhittincamdali/iOSAppTemplates/topics -H "Accept: application/vnd.github+json" --input -
import json
from pathlib import Path
payload = json.loads(Path("Documentation/github-distribution-policy.json").read_text())
print(json.dumps({"names": payload["topics"]}))
PY

echo "GitHub distribution metadata synced."
