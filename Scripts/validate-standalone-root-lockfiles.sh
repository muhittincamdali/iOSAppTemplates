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
  "Templates/EducationApp"
  "Templates/FoodDeliveryApp"
  "Templates/TravelPlannerApp"
  "Templates/AIAssistantApp"
)

required_doc_paths=(
  "Documentation/App-Proofs/EcommerceApp.md"
  "Documentation/App-Proofs/SocialMediaApp.md"
  "Documentation/App-Proofs/FitnessApp.md"
  "Documentation/App-Proofs/ProductivityApp.md"
  "Documentation/App-Proofs/FinanceApp.md"
  "Documentation/App-Proofs/EducationApp.md"
  "Documentation/App-Proofs/FoodDeliveryApp.md"
  "Documentation/App-Proofs/TravelPlannerApp.md"
  "Documentation/App-Proofs/AIAssistantApp.md"
  "Templates/EcommerceApp/README.md"
  "Templates/SocialMediaApp/README.md"
  "Templates/FitnessApp/README.md"
  "Templates/ProductivityApp/README.md"
  "Templates/FinanceApp/README.md"
  "Templates/EducationApp/README.md"
  "Templates/FoodDeliveryApp/README.md"
  "Templates/TravelPlannerApp/README.md"
  "Templates/AIAssistantApp/README.md"
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
require_pattern 'Templates/EducationApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention EducationApp lockfile coverage."
require_pattern 'Templates/FoodDeliveryApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention FoodDeliveryApp lockfile coverage."
require_pattern 'Templates/TravelPlannerApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention TravelPlannerApp lockfile coverage."
require_pattern 'Templates/AIAssistantApp/Package\.resolved' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention AIAssistantApp lockfile coverage."
require_pattern 'Templates/EcommerceApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/EcommerceApp.md" "EcommerceApp proof surface must mention the lockfile."
require_pattern 'Templates/SocialMediaApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/SocialMediaApp.md" "SocialMediaApp proof surface must mention the lockfile."
require_pattern 'Templates/FitnessApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FitnessApp.md" "FitnessApp proof surface must mention the lockfile."
require_pattern 'Templates/ProductivityApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/ProductivityApp.md" "ProductivityApp proof surface must mention the lockfile."
require_pattern 'Templates/FinanceApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FinanceApp.md" "FinanceApp proof surface must mention the lockfile."
require_pattern 'Templates/EducationApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/EducationApp.md" "EducationApp proof surface must mention the lockfile."
require_pattern 'Templates/FoodDeliveryApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/FoodDeliveryApp.md" "FoodDeliveryApp proof surface must mention the lockfile."
require_pattern 'Templates/TravelPlannerApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/TravelPlannerApp.md" "TravelPlannerApp proof surface must mention the lockfile."
require_pattern 'Templates/AIAssistantApp/Package\.resolved.*lockfile mevcut' "${repo_root}/Documentation/App-Proofs/AIAssistantApp.md" "AIAssistantApp proof surface must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/EcommerceApp/README.md" "EcommerceApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/SocialMediaApp/README.md" "SocialMediaApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FitnessApp/README.md" "FitnessApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/ProductivityApp/README.md" "ProductivityApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FinanceApp/README.md" "FinanceApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/EducationApp/README.md" "EducationApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/FoodDeliveryApp/README.md" "FoodDeliveryApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/TravelPlannerApp/README.md" "TravelPlannerApp template README must mention the lockfile."
require_pattern 'Package\.resolved.*lockfile mevcut' "${repo_root}/Templates/AIAssistantApp/README.md" "AIAssistantApp template README must mention the lockfile."

echo "Standalone root lockfile surfaces look good."
