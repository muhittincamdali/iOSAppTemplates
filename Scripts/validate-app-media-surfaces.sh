#!/bin/bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
policy_file="${repo_root}/Documentation/app-media-policy.json"
screenshots_dir="${repo_root}/Documentation/Assets/AppScreenshots"

if [[ ! -f "${policy_file}" ]]; then
  echo "Missing media policy: Documentation/app-media-policy.json" >&2
  exit 1
fi

required_docs=(
  "Documentation/App-Media/README.md"
  "Documentation/App-Gallery.md"
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
  "Documentation/App-Media/BookingReservationsApp.md"
  "Documentation/App-Media/NotesKnowledgeApp.md"
  "Documentation/App-Media/CreatorShortVideoApp.md"
  "Documentation/App-Media/TeamCollaborationApp.md"
  "Documentation/App-Media/CRMAdminApp.md"
  "Documentation/App-Media/SubscriptionLifestyleApp.md"
  "Documentation/App-Media/PrivacyVaultApp.md"
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

python3 - "${repo_root}" "${policy_file}" "${screenshots_dir}" <<'PY'
import json
import sys
from pathlib import Path

repo_root = Path(sys.argv[1])
policy_path = Path(sys.argv[2])
screenshot_dir = Path(sys.argv[3])

policy = json.loads(policy_path.read_text())
apps = policy.get("apps")
if not isinstance(apps, list) or len(apps) != 20:
    raise SystemExit("Media policy must define exactly 20 standalone apps.")

router = (repo_root / "Documentation" / "App-Media" / "README.md").read_text()
proof_router = (repo_root / "Documentation" / "App-Proofs" / "README.md").read_text()
proof_matrix = (repo_root / "Documentation" / "Proof-Matrix.md").read_text()

if "App-Gallery.md" not in router:
    raise SystemExit("Media router must link gallery surface.")
if "App-Media/README.md" not in proof_router:
    raise SystemExit("App proof router must link to media router.")
if "canonical per-app media pages exist" not in proof_matrix:
    raise SystemExit("Proof matrix must mention canonical media router.")

for item in apps:
    for key in ("id", "lane", "status", "required_readme"):
        if key not in item:
            raise SystemExit(f"Missing key '{key}' in media policy entry: {item}")

    app_id = item["id"]
    lane = item["lane"]
    media_page_path = repo_root / item["required_readme"]
    media_page = media_page_path.read_text()
    has_screenshot = (screenshot_dir / f"{app_id}.png").exists()
    expected_status = "screenshot-published" if has_screenshot else "preview-published"

    if item["status"] != expected_status:
        raise SystemExit(f"Unexpected media status for {app_id}: {item['status']} (expected {expected_status})")

    router_row = f"| {app_id} | {lane} | `{expected_status}` |"
    if router_row not in router:
        raise SystemExit(f"Media router must mention {app_id} status {expected_status}.")

    page_status = f"Media status: `{expected_status}`"
    if page_status not in media_page:
        raise SystemExit(f"{app_id} media page must declare status {expected_status}.")

    if has_screenshot:
        screenshot_link = f"../Assets/AppScreenshots/{app_id}.png"
        if screenshot_link not in media_page:
            raise SystemExit(f"{app_id} media page must link the runtime screenshot.")
    else:
        if "runtime screenshot is not yet published" not in media_page:
            raise SystemExit(f"{app_id} media page must state screenshot gap.")

print("App media surfaces look good.")
PY
