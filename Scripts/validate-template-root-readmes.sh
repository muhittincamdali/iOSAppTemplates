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

grep -Fq "Templates/EcommerceApp/README.md" Documentation/App-Proofs/EcommerceApp.md || { echo "Ecommerce proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/SocialMediaApp/README.md" Documentation/App-Proofs/SocialMediaApp.md || { echo "Social proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/FitnessApp/README.md" Documentation/App-Proofs/FitnessApp.md || { echo "Fitness proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/ProductivityApp/README.md" Documentation/App-Proofs/ProductivityApp.md || { echo "Productivity proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/FinanceApp/README.md" Documentation/App-Proofs/FinanceApp.md || { echo "Finance proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/EducationApp/README.md" Documentation/App-Proofs/EducationApp.md || { echo "Education proof page missing template README link" >&2; exit 1; }
grep -Fq "Templates/FoodDeliveryApp/README.md" Documentation/App-Proofs/FoodDeliveryApp.md || { echo "FoodDelivery proof page missing template README link" >&2; exit 1; }

echo "Template root README validation passed."
