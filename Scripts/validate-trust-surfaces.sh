#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_files=(
  "SUPPORT.md"
  "SECURITY.md"
  "CONTRIBUTING.md"
  "PROJECT_STATUS.md"
  "Documentation/GitHub-Distribution.md"
  "Documentation/Release-Process.md"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || { echo "Missing trust surface: $file" >&2; exit 1; }
done

grep -Fq "PROJECT_STATUS.md" README.md || { echo "README missing project status link" >&2; exit 1; }
grep -Fq "Documentation/GitHub-Distribution.md" README.md || { echo "README missing GitHub distribution link" >&2; exit 1; }
grep -Fq "Documentation/Release-Process.md" README.md || { echo "README missing release process link" >&2; exit 1; }

grep -Fq "../PROJECT_STATUS.md" Documentation/README.md || { echo "Documentation hub missing project status link" >&2; exit 1; }
grep -Fq "GitHub-Distribution.md" Documentation/README.md || { echo "Documentation hub missing GitHub distribution link" >&2; exit 1; }
grep -Fq "Release-Process.md" Documentation/README.md || { echo "Documentation hub missing release process link" >&2; exit 1; }

grep -Fq "SECURITY.md" SUPPORT.md || { echo "Support page missing security link" >&2; exit 1; }
grep -Fq "CONTRIBUTING.md" SUPPORT.md || { echo "Support page missing contributing link" >&2; exit 1; }
grep -Fq "GitHub-Distribution.md" SECURITY.md || { echo "Security page missing GitHub distribution link" >&2; exit 1; }

grep -Fq "INSERT CONTACT METHOD" CODE_OF_CONDUCT.md && { echo "Code of conduct still has placeholder contact" >&2; exit 1; }
grep -Fq "Public Claim Impact" .github/pull_request_template.md || { echo "PR template missing public claim section" >&2; exit 1; }
grep -Fq "Affected Path" .github/ISSUE_TEMPLATE/bug_report.yml || { echo "Bug report template missing affected path field" >&2; exit 1; }
grep -Fq "Proof Impact" .github/ISSUE_TEMPLATE/feature_request.yml || { echo "Feature request template missing proof impact field" >&2; exit 1; }

echo "Trust surface validation passed."
