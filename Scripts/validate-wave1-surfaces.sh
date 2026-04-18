#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_files=(
  "Documentation/Wave-1-Implementation-Plan.md"
  "Documentation/Wave-1-App-Pack-Spec.md"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { echo "Missing Wave 1 file: $file" >&2; exit 1; }
done

required_patterns=(
  "E-Commerce Store"
  "Social Media"
  "Productivity / Tasks"
  "Finance / Budgeting"
  "Education / Learning"
  "Food Delivery"
  "Travel Planner"
  "AI Assistant"
)

for pattern in "${required_patterns[@]}"; do
  grep -Fq "$pattern" Documentation/Wave-1-Implementation-Plan.md || { echo "Wave 1 plan missing: $pattern" >&2; exit 1; }
done

grep -Fq "Wave-1-Implementation-Plan.md" README.md || { echo "README missing Wave 1 plan link" >&2; exit 1; }
grep -Fq "Wave-1-Implementation-Plan.md" Documentation/README.md || { echo "Documentation hub missing Wave 1 plan link" >&2; exit 1; }
grep -Fq "Wave-1-App-Pack-Spec.md" Documentation/README.md || { echo "Documentation hub missing Wave 1 spec link" >&2; exit 1; }
grep -Fq "Wave-1-Implementation-Plan.md" Documentation/Portfolio-Matrix.md || { echo "Portfolio matrix missing Wave 1 plan link" >&2; exit 1; }
grep -Fq "Wave-1-Implementation-Plan.md" Examples/README.md || { echo "Examples hub missing Wave 1 plan link" >&2; exit 1; }
grep -Fq "Wave-1-App-Pack-Spec.md" Documentation/Proof-Matrix.md || { echo "Proof matrix missing Wave 1 spec link" >&2; exit 1; }

echo "Wave 1 surfaces look good."
