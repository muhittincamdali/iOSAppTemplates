#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_root="$repo_root/.build/runtime-screenshot-hosts"
project_name="iOSAppTemplatesRuntimeHosts"

sample_apps=(
  "ProductivityApp"
  "EcommerceApp"
  "SocialMediaApp"
)

apps_to_validate=("$@")
if [[ ${#apps_to_validate[@]} -eq 0 ]]; then
  apps_to_validate=("${sample_apps[@]}")
fi

command -v xcodegen >/dev/null 2>&1 || {
  echo "xcodegen is required for runtime screenshot hosts" >&2
  exit 1
}

python3 "$repo_root/Scripts/generate-runtime-screenshot-hosts.py"

(
  cd "$project_root"
  rm -rf "$project_root/$project_name.xcodeproj"
  xcodegen generate --spec project.json >/dev/null
)

for app in "${apps_to_validate[@]}"; do
  echo "Validating runtime host build for $app..."
  xcodebuild \
    -project "$project_root/$project_name.xcodeproj" \
    -scheme "${app}Runtime" \
    -destination 'generic/platform=iOS Simulator' \
    build >/dev/null
done

echo "Runtime screenshot host validation passed for:"
for app in "${apps_to_validate[@]}"; do
  echo "- $app"
done
