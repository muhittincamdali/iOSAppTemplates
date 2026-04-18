#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

require_pattern() {
  local pattern="$1"
  local file_path="$2"
  local error_message="$3"

  if ! grep -Eq "${pattern}" "${file_path}"; then
    echo "${error_message}" >&2
    exit 1
  fi
}

required_roots=(
  "Templates/EcommerceApp"
  "Templates/SocialMediaApp"
  "Templates/FitnessApp"
  "Templates/ProductivityApp"
  "Templates/FinanceApp"
)

required_doc_paths=(
  "Documentation/App-Proofs/EcommerceApp.md"
  "Documentation/App-Proofs/SocialMediaApp.md"
  "Documentation/App-Proofs/FitnessApp.md"
  "Documentation/App-Proofs/ProductivityApp.md"
  "Documentation/App-Proofs/FinanceApp.md"
  "Templates/EcommerceApp/README.md"
  "Templates/SocialMediaApp/README.md"
  "Templates/FitnessApp/README.md"
  "Templates/ProductivityApp/README.md"
  "Templates/FinanceApp/README.md"
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

require_pattern 'Templates/EcommerceApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention EcommerceApp lockfile coverage."
require_pattern 'Templates/SocialMediaApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention SocialMediaApp lockfile coverage."
require_pattern 'Templates/FitnessApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention FitnessApp lockfile coverage."
require_pattern 'Templates/ProductivityApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention ProductivityApp lockfile coverage."
require_pattern 'Templates/FinanceApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention FinanceApp lockfile coverage."
require_pattern 'Templates/EcommerceApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/EcommerceApp.md" "EcommerceApp proof surface must mention the lockfile."
require_pattern 'Templates/SocialMediaApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/SocialMediaApp.md" "SocialMediaApp proof surface must mention the lockfile."
require_pattern 'Templates/FitnessApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FitnessApp.md" "FitnessApp proof surface must mention the lockfile."
require_pattern 'Templates/ProductivityApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/ProductivityApp.md" "ProductivityApp proof surface must mention the lockfile."
require_pattern 'Templates/FinanceApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FinanceApp.md" "FinanceApp proof surface must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/EcommerceApp/README.md" "EcommerceApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/SocialMediaApp/README.md" "SocialMediaApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FitnessApp/README.md" "FitnessApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/ProductivityApp/README.md" "ProductivityApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FinanceApp/README.md" "FinanceApp template README must mention the lockfile."

echo "Standalone root lockfile surfaces look good."
