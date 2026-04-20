#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
policy_file="${repo_root}/Documentation/app-media-policy.json"

if [[ ! -f "${policy_file}" ]]; then
  echo "Missing media policy: Documentation/app-media-policy.json" >&2
  exit 1
fi

python3 - "${policy_file}" <<'PY'
import json
import sys
from pathlib import Path

path = Path(sys.argv[1])
with path.open("r", encoding="utf-8") as handle:
    payload = json.load(handle)

apps = payload.get("apps")
if not isinstance(apps, list) or len(apps) != 13:
    raise SystemExit("Media policy must define exactly 13 standalone apps.")

for item in apps:
    for key in ("id", "lane", "status", "required_readme"):
        if key not in item:
            raise SystemExit(f"Missing key '{key}' in media policy entry: {item}")
    if item["status"] != "not-published":
        raise SystemExit(f"Unexpected media status for {item['id']}: {item['status']}")
PY

required_docs=(
  "Documentation/App-Media/README.md"
  "Documentation/App-Media/EcommerceApp.md"
  "Documentation/App-Media/SocialMediaApp.md"
  "Documentation/App-Media/FitnessApp.md"
  "Documentation/App-Media/ProductivityApp.md"
  "Documentation/App-Media/FinanceApp.md"
  "Documentation/App-Media/EducationApp.md"
  "Documentation/App-Media/FoodDeliveryApp.md"
  "Documentation/App-Media/TravelPlannerApp.md"
  "Documentation/App-Media/AIAssistantApp.md"
  "Documentation/App-Media/NewsBlogApp.md"
  "Documentation/App-Media/MusicPodcastApp.md"
  "Documentation/App-Media/MarketplaceApp.md"
  "Documentation/App-Media/MessagingApp.md"
  "Documentation/app-media-policy.json"
  "Documentation/Proof-Matrix.md"
  "Documentation/App-Proofs/README.md"
)

for relative_path in "${required_docs[@]}"; do
  if [[ ! -f "${repo_root}/${relative_path}" ]]; then
    echo "Missing media surface: ${relative_path}" >&2
    exit 1
  fi
done

require_pattern() {
  local pattern="$1"
  local file_path="$2"
  local error_message="$3"

  if ! grep -Eq "${pattern}" "${file_path}"; then
    echo "${error_message}" >&2
    exit 1
  fi
}

require_pattern 'EcommerceApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention EcommerceApp status."
require_pattern 'SocialMediaApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention SocialMediaApp status."
require_pattern 'FitnessApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention FitnessApp status."
require_pattern 'ProductivityApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention ProductivityApp status."
require_pattern 'FinanceApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention FinanceApp status."
require_pattern 'EducationApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention EducationApp status."
require_pattern 'FoodDeliveryApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention FoodDeliveryApp status."
require_pattern 'TravelPlannerApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention TravelPlannerApp status."
require_pattern 'AIAssistantApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention AIAssistantApp status."
require_pattern 'NewsBlogApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention NewsBlogApp status."
require_pattern 'MusicPodcastApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention MusicPodcastApp status."
require_pattern 'MarketplaceApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention MarketplaceApp status."
require_pattern 'MessagingApp.*not-published' "${repo_root}/Documentation/App-Media/README.md" "Media router must mention MessagingApp status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/EcommerceApp.md" "EcommerceApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/SocialMediaApp.md" "SocialMediaApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/FitnessApp.md" "FitnessApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/ProductivityApp.md" "ProductivityApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/FinanceApp.md" "FinanceApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/EducationApp.md" "EducationApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/FoodDeliveryApp.md" "FoodDeliveryApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/TravelPlannerApp.md" "TravelPlannerApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/AIAssistantApp.md" "AIAssistantApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/NewsBlogApp.md" "NewsBlogApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/MusicPodcastApp.md" "MusicPodcastApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/MarketplaceApp.md" "MarketplaceApp media page must declare status."
require_pattern 'Media status: `not-published`' "${repo_root}/Documentation/App-Media/MessagingApp.md" "MessagingApp media page must declare status."
require_pattern 'App-Media/README\.md' "${repo_root}/Documentation/App-Proofs/README.md" "App proof router must link to media router."
require_pattern 'canonical per-app media pages exist' "${repo_root}/Documentation/Proof-Matrix.md" "Proof matrix must mention canonical media router."

echo "App media surfaces look good."
