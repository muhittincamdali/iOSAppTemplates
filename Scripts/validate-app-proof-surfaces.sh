#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_files=(
  "Documentation/App-Proofs/README.md"
  "Documentation/App-Proofs/EcommerceApp.md"
  "Documentation/App-Proofs/SocialMediaApp.md"
  "Documentation/App-Proofs/FitnessApp.md"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { echo "Missing app proof file: $file" >&2; exit 1; }
done

required_patterns=(
  "Templates/EcommerceApp/Package.swift"
  "Templates/SocialMediaApp/Package.swift"
  "Templates/FitnessApp/Package.swift"
  "swift package dump-package"
  "swift build -c release"
)

for file in "${required_files[@]:1}"; do
  for pattern in "${required_patterns[@]}"; do
    if [[ "$file" == *"EcommerceApp.md" && "$pattern" == "Templates/SocialMediaApp/Package.swift" ]]; then
      continue
    fi
    if [[ "$file" == *"EcommerceApp.md" && "$pattern" == "Templates/FitnessApp/Package.swift" ]]; then
      continue
    fi
    if [[ "$file" == *"SocialMediaApp.md" && "$pattern" == "Templates/EcommerceApp/Package.swift" ]]; then
      continue
    fi
    if [[ "$file" == *"SocialMediaApp.md" && "$pattern" == "Templates/FitnessApp/Package.swift" ]]; then
      continue
    fi
    if [[ "$file" == *"FitnessApp.md" && "$pattern" == "Templates/EcommerceApp/Package.swift" ]]; then
      continue
    fi
    if [[ "$file" == *"FitnessApp.md" && "$pattern" == "Templates/SocialMediaApp/Package.swift" ]]; then
      continue
    fi

    grep -Fq "$pattern" "$file" || { echo "$file missing pattern: $pattern" >&2; exit 1; }
  done
done

grep -Fq "Documentation/App-Proofs/README.md" README.md || { echo "README missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/README.md || { echo "Documentation hub missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/Template-Showcase.md || { echo "Template showcase missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/Proof-Matrix.md || { echo "Proof matrix missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Examples/README.md || { echo "Examples hub missing app proof router link" >&2; exit 1; }
grep -Fq "App-Proofs/README.md" Documentation/Guides/QuickStart.md || { echo "QuickStart missing app proof router link" >&2; exit 1; }

echo "App proof surface validation passed."
