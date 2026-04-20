#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

[[ -f ".github/workflows/standalone-ios-proof.yml" ]] || { echo "Missing standalone iOS proof workflow" >&2; exit 1; }

grep -Fq "Standalone iOS Proof" .github/workflows/standalone-ios-proof.yml || { echo "Workflow missing expected name" >&2; exit 1; }
grep -Fq "validate-standalone-ios-builds.sh" .github/workflows/standalone-ios-proof.yml || { echo "Workflow missing validator call" >&2; exit 1; }

grep -Fq "standalone-ios-proof.yml" README.md || { echo "README missing standalone iOS proof workflow link" >&2; exit 1; }
grep -Fq "standalone-ios-proof.yml" Documentation/README.md || { echo "Documentation hub missing standalone iOS proof workflow link" >&2; exit 1; }
grep -Fq "hosted standalone iOS proof workflow is active" PROJECT_STATUS.md || { echo "Project status missing hosted proof workflow status" >&2; exit 1; }
grep -Fq "hosted standalone iOS proof workflow is active" Documentation/Proof-Matrix.md || { echo "Proof matrix missing hosted proof workflow status" >&2; exit 1; }

echo "Standalone iOS proof surface validation passed."
