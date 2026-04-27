#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project_root="$repo_root/.build/runtime-screenshot-hosts"
project_name="iOSAppTemplatesRuntimeHosts"
derived_data_dir="$repo_root/.build/runtime-launch-derived-data"
runtime_flag="IOSAPPTEMPLATES_SCREENSHOT_MODE"
crash_reports_dir="${HOME}/Library/Logs/DiagnosticReports"

catalog_apps=()
while IFS= read -r app_name; do
  catalog_apps+=("$app_name")
done < <(
  python3 - "$repo_root/Documentation/app-surface-catalog.json" <<'PY'
import json
import sys
from pathlib import Path

catalog_path = Path(sys.argv[1])
catalog = json.loads(catalog_path.read_text())
for item in catalog:
    print(item["app"])
PY
)

apps_to_validate=("$@")
if [[ ${#apps_to_validate[@]} -eq 0 ]]; then
  apps_to_validate=("${catalog_apps[@]}")
fi

command -v xcodegen >/dev/null 2>&1 || {
  echo "xcodegen is required for runtime launch validation" >&2
  exit 1
}

python3 "$repo_root/Scripts/generate-runtime-screenshot-hosts.py"

(
  cd "$project_root"
  rm -rf "$project_root/$project_name.xcodeproj"
  xcodegen generate --spec project.json >/dev/null
)

simulator_id="$(
  "$repo_root/Scripts/resolve-runtime-simulator.sh"
)"

xcrun simctl boot "$simulator_id" >/dev/null 2>&1 || true
open -a Simulator --args -CurrentDeviceUDID "$simulator_id" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$simulator_id" -b

log_dir="$(mktemp -d)"
trap 'rm -rf "$log_dir"' EXIT

find_new_crash_report() {
  local app="$1"
  local marker_path="$2"

  find "$crash_reports_dir" \
    \( -name "${app}Runtime-*.ips" -o -name "${app}Runtime_*.ips" -o -name "${app}Runtime-*.crash" -o -name "${app}Runtime_*.crash" \) \
    -newer "$marker_path" \
    -print \
    -quit 2>/dev/null || true
}

for app in "${apps_to_validate[@]}"; do
  scheme="${app}Runtime"
  bundle_id="com.muhittincamdali.iOSAppTemplates.RuntimeHosts.${scheme}"
  build_log="$log_dir/${app}-build.log"
  launch_log="$log_dir/${app}-launch.log"
  marker_file="$log_dir/${app}.marker"

  echo "Validating runtime launch for $app..."

  xcodebuild \
    -project "$project_root/$project_name.xcodeproj" \
    -scheme "$scheme" \
    -destination "id=$simulator_id" \
    -derivedDataPath "$derived_data_dir" \
    build >"$build_log" 2>&1 || {
      echo "Runtime host build failed for $app" >&2
      tail -n 120 "$build_log" >&2 || true
      exit 1
    }

  app_path="$(find "$derived_data_dir/Build/Products" -path "*${scheme}.app" | head -n 1)"
  if [[ -z "$app_path" ]]; then
    echo "Unable to locate built runtime app for $app" >&2
    exit 1
  fi

  xcrun simctl uninstall "$simulator_id" "$bundle_id" >/dev/null 2>&1 || true
  xcrun simctl install "$simulator_id" "$app_path" >/dev/null

  touch "$marker_file"

  env "SIMCTL_CHILD_${runtime_flag}=1" \
    xcrun simctl launch --terminate-running-process "$simulator_id" "$bundle_id" >"$launch_log" 2>&1 || {
      echo "Runtime launch failed for $app" >&2
      cat "$launch_log" >&2 || true
      exit 1
    }

  sleep 4

  crash_report="$(find_new_crash_report "$app" "$marker_file")"
  if [[ -n "$crash_report" ]]; then
    echo "Runtime crash report detected for $app: $crash_report" >&2
    exit 1
  fi

  xcrun simctl terminate "$simulator_id" "$bundle_id" >/dev/null 2>&1 || {
    echo "Runtime app did not stay alive for $app" >&2
    cat "$launch_log" >&2 || true
    exit 1
  }
done

echo "Runtime launch validation passed for:"
for app in "${apps_to_validate[@]}"; do
  echo "- $app"
done
