#!/usr/bin/env bash
# Builds and tests template packages in the iOS Simulator.
#
# Usage:
#   scripts/test-templates.sh                      # every template
#   scripts/test-templates.sh EcommerceApp FitnessApp
#
# Environment:
#   SIMULATOR_DESTINATION  xcodebuild destination (default: first available iPhone simulator)
#   DERIVED_DATA_PATH      build directory (default: .build/templates)

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
templates_dir="$repo_root/Templates"
derived_data="${DERIVED_DATA_PATH:-$repo_root/.build/templates}"

default_destination() {
  local udid
  udid="$(xcrun simctl list devices available | grep -E '^\s+iPhone' | head -1 | grep -oE '[0-9A-F-]{36}')"
  [[ -n "$udid" ]] || { echo "No available iPhone simulator found." >&2; exit 1; }
  echo "platform=iOS Simulator,id=$udid"
}

destination="${SIMULATOR_DESTINATION:-$(default_destination)}"

templates=("$@")
if [[ ${#templates[@]} -eq 0 ]]; then
  while IFS= read -r name; do templates+=("$name"); done < <(ls "$templates_dir")
fi

mkdir -p "$derived_data"
failed=()
for template in "${templates[@]}"; do
  log="$derived_data/$template.log"
  if (cd "$templates_dir/$template" && xcodebuild test \
        -scheme "$template" \
        -destination "$destination" \
        -derivedDataPath "$derived_data/$template" > "$log" 2>&1); then
    echo "$template: $(grep -E 'Test run with' "$log" | tail -1 | sed -E 's/^[^A-Za-z]*//')"
  else
    echo "$template: FAILED (full log: $log)" >&2
    grep -E 'error:|recorded an issue|failed after' "$log" | head -40 >&2 || true
    failed+=("$template")
  fi
done

if [[ ${#failed[@]} -gt 0 ]]; then
  echo "Failed: ${failed[*]}" >&2
  exit 1
fi
echo "All ${#templates[@]} template packages passed."
