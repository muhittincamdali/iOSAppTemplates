#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

tracked_apps=(
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
)

log_dir="$(mktemp -d)"
trap 'rm -rf "$log_dir"' EXIT

for app in "${tracked_apps[@]}"; do
  log_file="$log_dir/${app}.log"
  echo "Validating generic iOS build for $app..."
  (
    cd "$repo_root/Templates/$app"
    xcodebuild -scheme "$app" -destination 'generic/platform=iOS' build >"$log_file" 2>&1
  ) || {
    echo "Generic iOS build failed for $app" >&2
    tail -n 80 "$log_file" >&2 || true
    exit 1
  }
done

echo "Tracked generic iOS build proof passed for:"
for app in "${tracked_apps[@]}"; do
  echo "- $app"
done
