#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required_roots=(
  "Templates/SocialMediaApp"
  "Templates/FitnessApp"
)

required_doc_paths=(
  "Documentation/App-Proofs/SocialMediaApp.md"
  "Documentation/App-Proofs/FitnessApp.md"
  "Templates/SocialMediaApp/README.md"
  "Templates/FitnessApp/README.md"
  "Documentation/Proof-Matrix.md"
  "Documentation/Template-Showcase.md"
)

for root in "${required_roots[@]}"; do
  package_file="${repo_root}/${root}/Package.swift"
  resolved_file="${repo_root}/${root}/Package.resolved"

  if [[ ! -f "${package_file}" ]]; then
    echo "Missing package manifest: ${root}/Package.swift" >&2
    exit 1
  fi

  if [[ ! -f "${resolved_file}" ]]; then
    echo "Missing lockfile: ${root}/Package.resolved" >&2
    exit 1
  fi

  python3 - "${resolved_file}" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
with path.open("r", encoding="utf-8") as handle:
    payload = json.load(handle)

pins = payload.get("pins")
if not isinstance(pins, list) or not pins:
    raise SystemExit(f"Lockfile has no pins: {path}")
PY
done

for relative_path in "${required_doc_paths[@]}"; do
  file_path="${repo_root}/${relative_path}"

  if [[ ! -f "${file_path}" ]]; then
    echo "Missing documentation surface: ${relative_path}" >&2
    exit 1
  fi
done

if ! rg -q 'Templates/SocialMediaApp/Package.resolved' "${repo_root}/Documentation/Proof-Matrix.md"; then
  echo "Proof matrix must mention SocialMediaApp lockfile coverage." >&2
  exit 1
fi

if ! rg -q 'Templates/FitnessApp/Package.resolved' "${repo_root}/Documentation/Proof-Matrix.md"; then
  echo "Proof matrix must mention FitnessApp lockfile coverage." >&2
  exit 1
fi

if ! rg -q 'Templates/SocialMediaApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/SocialMediaApp.md"; then
  echo "SocialMediaApp proof surface must mention the lockfile." >&2
  exit 1
fi

if ! rg -q 'Templates/FitnessApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FitnessApp.md"; then
  echo "FitnessApp proof surface must mention the lockfile." >&2
  exit 1
fi

if ! rg -q 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/SocialMediaApp/README.md"; then
  echo "SocialMediaApp template README must mention the lockfile." >&2
  exit 1
fi

if ! rg -q 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FitnessApp/README.md"; then
  echo "FitnessApp template README must mention the lockfile." >&2
  exit 1
fi

echo "Standalone root lockfile surfaces look good."
