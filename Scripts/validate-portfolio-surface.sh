#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_files=(
  "Documentation/Portfolio-Matrix.md"
  "Documentation/Template-Showcase.md"
  "Documentation/Proof-Matrix.md"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { echo "Missing required portfolio file: $file" >&2; exit 1; }
done

required_patterns=(
  "Templates/EcommerceApp"
  "Templates/SocialMediaApp"
  "Templates/FitnessApp"
  "Templates/ProductivityApp"
  "Templates/FinanceApp"
  "swift Scripts/TemplateGenerator.swift --list"
)

for pattern in "${required_patterns[@]}"; do
  grep -Fq "$pattern" Documentation/Portfolio-Matrix.md || { echo "Portfolio matrix missing pattern: $pattern" >&2; exit 1; }
done

grep -Fq "Documentation/Portfolio-Matrix.md" README.md || { echo "README missing portfolio link" >&2; exit 1; }
grep -Fq "Template-Showcase.md" Documentation/README.md || { echo "Documentation hub missing showcase link" >&2; exit 1; }
grep -Fq "Proof-Matrix.md" Documentation/README.md || { echo "Documentation hub missing proof matrix link" >&2; exit 1; }
grep -Fq "Portfolio-Matrix.md" Examples/README.md || { echo "Examples hub missing portfolio link" >&2; exit 1; }
grep -Fq "Template-Showcase.md" Documentation/Guides/QuickStart.md || { echo "QuickStart missing showcase link" >&2; exit 1; }
grep -Fq "Proof-Matrix.md" Documentation/TemplateGuide.md || { echo "TemplateGuide missing proof matrix link" >&2; exit 1; }

echo "Portfolio surface validation passed."
