#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

roots=(
  "Templates/EcommerceApp"
  "Templates/SocialMediaApp"
  "Templates/FitnessApp"
  "Templates/ProductivityApp"
  "Templates/FinanceApp"
  "Templates/EducationApp"
  "Templates/FoodDeliveryApp"
  "Templates/TravelPlannerApp"
  "Templates/AIAssistantApp"
  "Templates/NewsBlogApp"
  "Templates/MusicPodcastApp"
)

tracked_ios_build_apps=(
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
)

for root in "${roots[@]}"; do
  readme="$root/README.md"
  package="$root/Package.swift"

  [[ -f "$readme" ]] || { echo "Missing template root README: $readme" >&2; exit 1; }
  [[ -f "$package" ]] || { echo "Missing template root package: $package" >&2; exit 1; }

  grep -Fq "open Package.swift" "$readme" || { echo "$readme missing package start path" >&2; exit 1; }
  grep -Fq "../../Documentation/App-Proofs/" "$readme" || { echo "$readme missing canonical app proof link" >&2; exit 1; }
  grep -Fq "swift build" "$readme" || { echo "$readme missing repo build proof path" >&2; exit 1; }
  grep -Fq "swift test" "$readme" || { echo "$readme missing repo test proof path" >&2; exit 1; }
done

for app_name in "${tracked_ios_build_apps[@]}"; do
  readme="Templates/${app_name}/README.md"
  ios_build_command="xcodebuild -scheme ${app_name} -destination 'generic/platform=iOS' build"
  grep -Fq "$ios_build_command" "$readme" || { echo "$readme missing tracked iOS build command" >&2; exit 1; }
done

grep -Fq "Templates/EcommerceApp/README.md" Documentation/App-Proofs/EcommerceApp.md || { echo "Ecommerce proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/SocialMediaApp/README.md" Documentation/App-Proofs/SocialMediaApp.md || { echo "Social proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/FitnessApp/README.md" Documentation/App-Proofs/FitnessApp.md || { echo "Fitness proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/ProductivityApp/README.md" Documentation/App-Proofs/ProductivityApp.md || { echo "Productivity proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/FinanceApp/README.md" Documentation/App-Proofs/FinanceApp.md || { echo "Finance proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/EducationApp/README.md" Documentation/App-Proofs/EducationApp.md || { echo "Education proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/FoodDeliveryApp/README.md" Documentation/App-Proofs/FoodDeliveryApp.md || { echo "FoodDelivery proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/TravelPlannerApp/README.md" Documentation/App-Proofs/TravelPlannerApp.md || { echo "TravelPlanner proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/AIAssistantApp/README.md" Documentation/App-Proofs/AIAssistantApp.md || { echo "AIAssistant proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/NewsBlogApp/README.md" Documentation/App-Proofs/NewsBlogApp.md || { echo "NewsBlog proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/MusicPodcastApp/README.md" Documentation/App-Proofs/MusicPodcastApp.md || { echo "MusicPodcast proof page missing template README link" >&2; exit 1; }

echo "Template root README validation passed."
