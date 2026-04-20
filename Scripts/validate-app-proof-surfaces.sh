#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_files=(
  "Documentation/App-Proofs/README.md"
  "Documentation/App-Proofs/EcommerceApp.md"
  "Documentation/App-Proofs/SocialMediaApp.md"
  "Documentation/App-Proofs/FitnessApp.md"
  "Documentation/App-Proofs/ProductivityApp.md"
  "Documentation/App-Proofs/FinanceApp.md"
  "Documentation/App-Proofs/EducationApp.md"
  "Documentation/App-Proofs/FoodDeliveryApp.md"
  "Documentation/App-Proofs/TravelPlannerApp.md"
  "Documentation/App-Proofs/AIAssistantApp.md"
)

tracked_ios_build_apps=(
  "SocialMediaApp"
  "FitnessApp"
  "ProductivityApp"
  "FinanceApp"
  "EducationApp"
  "FoodDeliveryApp"
  "TravelPlannerApp"
  "AIAssistantApp"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { echo "Missing app proof file: $file" >&2; exit 1; }
done

generic_patterns=(
  "swift package dump-package"
  "swift build -c release"
)

for file in "${required_files[@]:1}"; do
  app_name="$(basename "$file" .md)"
  app_package="Templates/${app_name}/Package.swift"

  grep -Fq "$app_package" "$file" || { echo "$file missing pattern: $app_package" >&2; exit 1; }

  for pattern in "${generic_patterns[@]}"; do
    grep -Fq "$pattern" "$file" || { echo "$file missing pattern: $pattern" >&2; exit 1; }
  done
done

for app_name in "${tracked_ios_build_apps[@]}"; do
  file="Documentation/App-Proofs/${app_name}.md"
  ios_build_command="xcodebuild -scheme ${app_name} -destination 'generic/platform=iOS' build"
  grep -Fq "$ios_build_command" "$file" || { echo "$file missing tracked iOS build command" >&2; exit 1; }
done

grep -Fq "Documentation/App-Proofs/README.md" README.md || { echo "README missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/README.md || { echo "Documentation hub missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/Template-Showcase.md || { echo "Template showcase missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/Proof-Matrix.md || { echo "Proof matrix missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Examples/README.md || { echo "Examples hub missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/Guides/QuickStart.md || { echo "QuickStart missing app proof router link" >&2; exit 1; }
grep -Fq "validate-standalone-ios-builds.sh" Documentation/Proof-Matrix.md || { echo "Proof matrix missing standalone iOS build validator" >&2; exit 1; }

echo "App proof surface validation passed."
