#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

python3 Scripts/generate-app-surface-docs.py --check
echo "Generated app surface docs validation passed."
