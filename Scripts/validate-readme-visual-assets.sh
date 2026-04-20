#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

assets=(
  "Documentation/Assets/Readme/iosapptemplates-hero.svg"
  "Documentation/Assets/Readme/iosapptemplates-portfolio-board.svg"
)

for asset in "${assets[@]}"; do
  [[ -f "$asset" ]] || { echo "Missing visual asset: $asset" >&2; exit 1; }
  grep -Fq "<svg" "$asset" || { echo "Invalid svg asset: $asset" >&2; exit 1; }
done

grep -Fq "Documentation/Assets/Readme/iosapptemplates-hero.svg" README.md || { echo "README missing hero asset link" >&2; exit 1; }
grep -Fq "Documentation/Assets/Readme/iosapptemplates-portfolio-board.svg" README.md || { echo "README missing portfolio board asset link" >&2; exit 1; }

echo "README visual assets validation passed."
