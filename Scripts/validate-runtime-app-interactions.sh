#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_root="$repo_root/.build/runtime-screenshot-hosts"
project_name="iOSAppTemplatesRuntimeHosts"
derived_data_dir="$repo_root/.build/runtime-interaction-derived-data"
runtime_flag="IOSAPPTEMPLATES_SCREENSHOT_MODE"
interaction_flag="IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"

default_apps=(
  "EcommerceApp"
  "SocialMediaApp"
  "ProductivityApp"
  "FinanceApp"
  "EducationApp"
  "FoodDeliveryApp"
  "TravelPlannerApp"
  "AIAssistantApp"
  "NewsBlogApp"
  "MusicPodcastApp"
  "MarketplaceApp"
  "MessagingApp"
  "BookingReservationsApp"
  "NotesKnowledgeApp"
  "CreatorShortVideoApp"
  "TeamCollaborationApp"
  "CRMAdminApp"
  "SubscriptionLifestyleApp"
)

apps_to_validate=("$@")
if [[ ${#apps_to_validate[@]} -eq 0 ]]; then
  apps_to_validate=("${default_apps[@]}")
fi

command -v xcodegen >/dev/null 2>&1 || {
  echo "xcodegen is required for runtime interaction validation" >&2
  exit 1
}

python3 "$repo_root/Scripts/generate-runtime-screenshot-hosts.py"

(
  cd "$project_root"
  rm -rf "$project_root/$project_name.xcodeproj"
  xcodegen generate --spec project.json >/dev/null
)

simulator_id="$("$repo_root/Scripts/resolve-runtime-simulator.sh")"

xcrun simctl boot "$simulator_id" >/dev/null 2>&1 || true
open -a Simulator --args -CurrentDeviceUDID "$simulator_id" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$simulator_id" -b

log_dir="$(mktemp -d)"
trap 'rm -rf "$log_dir"' EXIT

for app in "${apps_to_validate[@]}"; do
  scheme="${app}Runtime"
  bundle_id="com.muhittincamdali.iOSAppTemplates.RuntimeHosts.${scheme}"
  build_log="$log_dir/${app}-build.log"
  launch_log="$log_dir/${app}-launch.log"

  echo "Validating automated interaction proof for $app..."

  xcodebuild \
    -project "$project_root/$project_name.xcodeproj" \
    -scheme "$scheme" \
    -destination "id=$simulator_id" \
    -derivedDataPath "$derived_data_dir" \
    build >"$build_log" 2>&1 || {
      echo "Runtime host build failed for $app" >&2
      tail -n 120 "$build_log" >&2 || true
      exit 1
    }

  app_path="$(find "$derived_data_dir/Build/Products" -path "*${scheme}.app" | head -n 1)"
  if [[ -z "$app_path" ]]; then
    echo "Unable to locate built runtime app for $app" >&2
    exit 1
  fi

  xcrun simctl uninstall "$simulator_id" "$bundle_id" >/dev/null 2>&1 || true
  xcrun simctl install "$simulator_id" "$app_path" >/dev/null

  container_path="$(xcrun simctl get_app_container "$simulator_id" "$bundle_id" data)"
  proof_file="$container_path/Documents/interaction-proof.json"
  rm -f "$proof_file"

  env "SIMCTL_CHILD_${runtime_flag}=1" "SIMCTL_CHILD_${interaction_flag}=1" \
    xcrun simctl launch --terminate-running-process "$simulator_id" "$bundle_id" >"$launch_log" 2>&1 || {
      echo "Runtime interaction launch failed for $app" >&2
      cat "$launch_log" >&2 || true
      exit 1
    }

  interaction_completed="0"
  for _ in {1..20}; do
    if [[ -f "$proof_file" ]]; then
      interaction_completed="1"
      break
    fi
    sleep 1
  done

  if [[ "$interaction_completed" != "1" ]]; then
    echo "Automated interaction proof file missing for $app" >&2
    cat "$launch_log" >&2 || true
    exit 1
  fi

  python3 - "$proof_file" "$app" <<'PY'
import json
import sys
from pathlib import Path

proof_path = Path(sys.argv[1])
app_name = sys.argv[2]
payload = json.loads(proof_path.read_text())

if payload.get("app") != app_name:
    raise SystemExit(f"Interaction proof app mismatch for {app_name}")
if payload.get("status") != "completed":
    raise SystemExit(f"Interaction proof status is not completed for {app_name}")
if not isinstance(payload.get("summary"), str) or not payload["summary"].strip():
    raise SystemExit(f"Interaction proof summary missing for {app_name}")
steps = payload.get("steps")
if not isinstance(steps, list) or len(steps) < 3:
    raise SystemExit(f"Interaction proof steps missing for {app_name}")
PY

  xcrun simctl terminate "$simulator_id" "$bundle_id" >/dev/null 2>&1 || true
done

echo "Automated runtime interaction proof passed for:"
for app in "${apps_to_validate[@]}"; do
  echo "- $app"
done
