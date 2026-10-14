#!/usr/bin/env bash
# Fails when the README version badge does not show the newest released
# version in CHANGELOG.md, so a release cannot ship with a stale badge.
#
# Usage: scripts/check-version-badge.sh

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
brand_dir="$repo_root/.github/brand"

changelog_version="$(grep -m1 -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' "$repo_root/CHANGELOG.md" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
if [[ -z "$changelog_version" ]]; then
  echo "No released version found in CHANGELOG.md" >&2
  exit 1
fi

status=0
for theme in light dark; do
  badge="$brand_dir/badge-version-$theme.svg"
  if ! grep -q "<title id=\"t\">Release: v$changelog_version</title>" "$badge"; then
    echo "$badge does not show v$changelog_version" >&2
    status=1
  fi
done

for readme in "$repo_root"/README*.md; do
  if ! grep -q "badge-version-light.svg\" alt=\"[^\"]*v$changelog_version\"" "$readme"; then
    echo "$readme badge alt text does not show v$changelog_version" >&2
    status=1
  fi
done

if [[ $status -eq 0 ]]; then
  echo "Version badge matches CHANGELOG: v$changelog_version"
fi
exit $status
