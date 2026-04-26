#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
catalog_path="${repo_root}/Documentation/app-surface-catalog.json"
scenario_router="${repo_root}/Documentation/App-Scenarios/README.md"

[[ -f "$catalog_path" ]] || { echo "Missing catalog: $catalog_path" >&2; exit 1; }
[[ -f "$scenario_router" ]] || { echo "Missing scenario router: Documentation/App-Scenarios/README.md" >&2; exit 1; }

python3 - "${repo_root}" "${catalog_path}" "${scenario_router}" <<'PY'
import json
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])
catalog = json.loads(Path(sys.argv[2]).read_text())
router = Path(sys.argv[3]).read_text()

if "`20` standalone roots have published launch-to-ready scenario frame pairs" not in router:
    raise SystemExit("Scenario router must mention 20 published scenario pairs.")

for item in catalog:
    app = item["app"]
    page_path = repo_root / "Documentation" / "App-Scenarios" / f"{app}.md"
    if not page_path.exists():
        raise SystemExit(f"Missing scenario page for {app}")
    page = page_path.read_text()

    launch_link = f"../Assets/AppScenarioShots/{app}-launch.png"
    ready_link = f"../Assets/AppScenarioShots/{app}-ready.png"
    screenshot_link = f"../Assets/AppScreenshots/{app}.png"
    clip_link = f"../Assets/AppDemoClips/{app}.mp4"

    for expected in (launch_link, ready_link, screenshot_link, clip_link):
        if expected not in page:
            raise SystemExit(f"{app} scenario page missing {expected}")

    router_row = f"| {app} | {item['lane']} | `published` |"
    if router_row not in router:
        raise SystemExit(f"Scenario router missing published row for {app}")

print("App scenario pages validation passed.")
PY
