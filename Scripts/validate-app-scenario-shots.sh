#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
scenario_dir="${repo_root}/Documentation/Assets/AppScenarioShots"
gallery_path="${repo_root}/Documentation/App-Gallery.md"
media_router_path="${repo_root}/Documentation/App-Media/README.md"
catalog_path="${repo_root}/Documentation/app-surface-catalog.json"

[[ -d "${scenario_dir}" ]] || {
  echo "Missing scenario shots directory: Documentation/Assets/AppScenarioShots" >&2
  exit 1
}

python3 - "${repo_root}" "${catalog_path}" "${scenario_dir}" "${gallery_path}" "${media_router_path}" <<'PY'
import json
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])
catalog_path = Path(sys.argv[2])
scenario_dir = Path(sys.argv[3])
gallery_path = Path(sys.argv[4])
media_router_path = Path(sys.argv[5])

catalog = json.loads(catalog_path.read_text())
gallery = gallery_path.read_text()
media_router = media_router_path.read_text()

if "`20` standalone roots already have published launch-to-ready scenario frame pairs" not in media_router:
    raise SystemExit("Media router must mention launch-to-ready scenario frame coverage.")

if "`20` apps already have published launch-to-ready scenario frame pairs" not in gallery:
    raise SystemExit("Gallery must mention launch-to-ready scenario frame coverage.")

for item in catalog:
    app = item["app"]
    launch_path = scenario_dir / f"{app}-launch.png"
    ready_path = scenario_dir / f"{app}-ready.png"
    if not launch_path.exists() or launch_path.stat().st_size == 0:
        raise SystemExit(f"Missing launch scenario frame for {app}")
    if not ready_path.exists() or ready_path.stat().st_size == 0:
        raise SystemExit(f"Missing ready scenario frame for {app}")

    launch_link = f"./Assets/AppScenarioShots/{app}-launch.png"
    ready_link = f"./Assets/AppScenarioShots/{app}-ready.png"
    if launch_link not in gallery or ready_link not in gallery:
        raise SystemExit(f"Gallery must link both scenario frames for {app}.")

    media_page_path = repo_root / "Documentation" / "App-Media" / f"{app}.md"
    media_page = media_page_path.read_text()
    if f"../Assets/AppScenarioShots/{app}-launch.png" not in media_page:
        raise SystemExit(f"Media page must link launch frame for {app}.")
    if f"../Assets/AppScenarioShots/{app}-ready.png" not in media_page:
        raise SystemExit(f"Media page must link ready frame for {app}.")

print("Runtime scenario shots look good.")
PY
