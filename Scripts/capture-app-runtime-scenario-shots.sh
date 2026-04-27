#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_root="$repo_root/.build/runtime-screenshot-hosts"
project_name="iOSAppTemplatesRuntimeHosts"
scenario_dir="$repo_root/Documentation/Assets/AppScenarioShots"
derived_data_dir="$repo_root/.build/runtime-scenario-derived-data"
runtime_flag="IOSAPPTEMPLATES_SCREENSHOT_MODE"
launch_delay_seconds="1"
ready_delay_seconds="3"

default_apps=(
  "EcommerceApp"
  "SocialMediaApp"
  "FitnessApp"
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
  "PrivacyVaultApp"
)

apps_to_capture=("$@")
if [[ ${#apps_to_capture[@]} -eq 0 ]]; then
  apps_to_capture=("${default_apps[@]}")
fi

command -v xcodegen >/dev/null 2>&1 || {
  echo "xcodegen is required for runtime scenario capture" >&2
  exit 1
}

mkdir -p "$scenario_dir"
python3 "$repo_root/Scripts/generate-runtime-screenshot-hosts.py"

(
  cd "$project_root"
  rm -rf "$project_root/$project_name.xcodeproj"
  xcodegen generate --spec project.json >/dev/null
)

simulator_id="$(
  "$repo_root/Scripts/resolve-runtime-simulator.sh"
)"

xcrun simctl boot "$simulator_id" >/dev/null 2>&1 || true
open -a Simulator --args -CurrentDeviceUDID "$simulator_id" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$simulator_id" -b

for app in "${apps_to_capture[@]}"; do
  scheme="${app}Runtime"
  bundle_id="com.muhittincamdali.iOSAppTemplates.RuntimeHosts.${scheme}"
  launch_path="$scenario_dir/${app}-launch.png"
  ready_path="$scenario_dir/${app}-ready.png"

  echo "Capturing launch-to-ready scenario frames for $app..."

  xcodebuild \
    -project "$project_root/$project_name.xcodeproj" \
    -scheme "$scheme" \
    -destination "id=$simulator_id" \
    -derivedDataPath "$derived_data_dir" \
    build >/dev/null

  app_path="$(find "$derived_data_dir/Build/Products" -path "*${scheme}.app" | head -n 1)"
  if [[ -z "$app_path" ]]; then
    echo "Unable to locate built app for $app" >&2
    exit 1
  fi

  rm -f "$launch_path" "$ready_path"
  xcrun simctl uninstall "$simulator_id" "$bundle_id" >/dev/null 2>&1 || true
  xcrun simctl install "$simulator_id" "$app_path" >/dev/null

  env "SIMCTL_CHILD_${runtime_flag}=1" \
    xcrun simctl launch --terminate-running-process "$simulator_id" "$bundle_id" >/dev/null

  sleep "$launch_delay_seconds"
  xcrun simctl io "$simulator_id" screenshot "$launch_path" >/dev/null

  sleep "$ready_delay_seconds"
  xcrun simctl io "$simulator_id" screenshot "$ready_path" >/dev/null

  xcrun simctl terminate "$simulator_id" "$bundle_id" >/dev/null 2>&1 || true

  if [[ ! -s "$launch_path" || ! -s "$ready_path" ]]; then
    echo "Failed to capture non-empty scenario frames for $app" >&2
    exit 1
  fi
done

echo "Captured launch-to-ready scenario frames for:"
for app in "${apps_to_capture[@]}"; do
  echo "- $app"
done
