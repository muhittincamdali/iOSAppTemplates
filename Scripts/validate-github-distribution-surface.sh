#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

policy_file="Documentation/github-distribution-policy.json"
python3 Scripts/validate-github-distribution-policy.py "$policy_file" >/dev/null

grep -Fq "github-distribution-policy.json" Documentation/GitHub-Distribution.md || {
  echo "GitHub distribution doc missing policy link" >&2
  exit 1
}

grep -Fq "SwiftUI starter portfolio with 20 tracked app templates, standalone roots, proof surfaces, and gallery assets." Documentation/GitHub-Distribution.md || {
  echo "GitHub distribution doc missing current description" >&2
  exit 1
}

grep -Fq "v2.0.0 - truth-first starter portfolio baseline" Documentation/GitHub-Distribution.md || {
  echo "GitHub distribution doc missing current release title" >&2
  exit 1
}

grep -Fq "sync-github-distribution.sh" Documentation/GitHub-Distribution.md || {
  echo "GitHub distribution doc missing sync command" >&2
  exit 1
}

grep -Fq "validate-github-distribution-surface.sh" Documentation/Release-Process.md || {
  echo "Release process missing GitHub distribution validator" >&2
  exit 1
}

grep -Fq "GitHub-Distribution.md" README.md || {
  echo "README missing GitHub distribution link" >&2
  exit 1
}

echo "GitHub distribution surface validation passed."
