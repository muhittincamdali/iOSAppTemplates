#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_root="$repo_root/.build/runtime-screenshot-hosts"
project_name="iOSAppTemplatesRuntimeHosts"
clips_dir="$repo_root/Documentation/Assets/AppDemoClips"
derived_data_dir="$repo_root/.build/runtime-demo-derived-data"
runtime_flag="IOSAPPTEMPLATES_SCREENSHOT_MODE"
clip_duration_seconds="5"
lock_dir="$repo_root/.build/runtime-capture.lock"

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
  echo "xcodegen is required for runtime demo capture" >&2
  exit 1
}

mkdir -p "$clips_dir"

while ! mkdir "$lock_dir" 2>/dev/null; do
  sleep 1
done

cleanup() {
  rmdir "$lock_dir" >/dev/null 2>&1 || true
}

trap cleanup EXIT

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
  clip_path="$clips_dir/${app}.mp4"

  echo "Capturing runtime demo clip for $app..."

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

  rm -f "$clip_path"
  xcrun simctl uninstall "$simulator_id" "$bundle_id" >/dev/null 2>&1 || true
  xcrun simctl install "$simulator_id" "$app_path" >/dev/null

  xcrun simctl io "$simulator_id" recordVideo --codec=h264 "$clip_path" >/dev/null 2>&1 &
  recorder_pid=$!
  sleep 1

  env "SIMCTL_CHILD_${runtime_flag}=1" \
    xcrun simctl launch --terminate-running-process "$simulator_id" "$bundle_id" >/dev/null

  sleep "$clip_duration_seconds"

  xcrun simctl terminate "$simulator_id" "$bundle_id" >/dev/null 2>&1 || true
  kill -INT "$recorder_pid" >/dev/null 2>&1 || true
  wait "$recorder_pid" >/dev/null 2>&1 || true

  if [[ ! -s "$clip_path" ]]; then
    echo "Failed to capture non-empty demo clip for $app" >&2
    exit 1
  fi
done

echo "Captured runtime demo clips for:"
for app in "${apps_to_capture[@]}"; do
  echo "- $app"
done
