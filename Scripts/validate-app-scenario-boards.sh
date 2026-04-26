#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
boards_dir="${repo_root}/Documentation/Assets/AppScenarioBoards"
scenario_router="${repo_root}/Documentation/App-Scenarios/README.md"
catalog_path="${repo_root}/Documentation/app-surface-catalog.json"

[[ -d "$boards_dir" ]] || { echo "Missing scenario boards directory: Documentation/Assets/AppScenarioBoards" >&2; exit 1; }

python3 - "${repo_root}" "${catalog_path}" "${boards_dir}" "${scenario_router}" <<'PY'
import json
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])
catalog = json.loads(Path(sys.argv[2]).read_text())
boards_dir = Path(sys.argv[3])
router = Path(sys.argv[4]).read_text()

if "`20` standalone roots have published shareable scenario boards" not in router:
    raise SystemExit("Scenario router must mention scenario board coverage.")

for item in catalog:
    app = item["app"]
    board_path = boards_dir / f"{app}.svg"
    if not board_path.exists() or board_path.stat().st_size == 0:
        raise SystemExit(f"Missing scenario board for {app}")

    if f"../Assets/AppScenarioBoards/{app}.svg" not in router:
        raise SystemExit(f"Scenario router must link board for {app}")

    page = (repo_root / "Documentation" / "App-Scenarios" / f"{app}.md").read_text()
    if f"../Assets/AppScenarioBoards/{app}.svg" not in page:
        raise SystemExit(f"Scenario page must link board for {app}")

print("App scenario boards validation passed.")
PY
