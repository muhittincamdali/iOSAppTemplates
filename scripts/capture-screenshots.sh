#!/usr/bin/env bash
# Builds each template's host app, runs it in the iOS Simulator and saves a light and a
# dark screenshot (JPEG) of the first screen to docs/images/.
#
# Requirements: Xcode 16 or later, XcodeGen (`brew install xcodegen`).
#
# Usage:
#   scripts/capture-screenshots.sh                 # all templates, dedicated simulator
#   scripts/capture-screenshots.sh EcommerceApp    # selected templates
#
# Environment:
#   SIMULATOR_UDID     use an existing simulator instead of creating one
#   DERIVED_DATA_PATH  build directory (default: .build/screenshots)
#   SCREENSHOT_WIDTH   output width in pixels (default: 390)
#   JPEG_QUALITY       0-100 (default: 80)
#   LAUNCH_WAIT        seconds to wait after launch before capturing (default: 4)

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
templates_dir="$repo_root/Templates"
output_dir="$repo_root/docs/images"
derived_data="${DERIVED_DATA_PATH:-$repo_root/.build/screenshots}"
width="${SCREENSHOT_WIDTH:-390}"
quality="${JPEG_QUALITY:-80}"
launch_wait="${LAUNCH_WAIT:-4}"
simulator_name="iOSAppTemplates Screenshots"

command -v xcodegen >/dev/null || { echo "xcodegen is required: brew install xcodegen" >&2; exit 1; }

resolve_simulator() {
  if [[ -n "${SIMULATOR_UDID:-}" ]]; then
    echo "$SIMULATOR_UDID"
    return
  fi

  local existing
  existing="$(xcrun simctl list devices available | grep -F "$simulator_name (" | head -1 | grep -oE '[0-9A-F-]{36}' || true)"
  if [[ -n "$existing" ]]; then
    echo "$existing"
    return
  fi

  local runtime device_type
  runtime="$(xcrun simctl list runtimes available | grep -oE 'com\.apple\.CoreSimulator\.SimRuntime\.iOS-[0-9-]+' | tail -1)"
  device_type="$(xcrun simctl list devicetypes | grep -oE 'com\.apple\.CoreSimulator\.SimDeviceType\.iPhone-[0-9]+-Pro\b' | tail -1)"
  xcrun simctl create "$simulator_name" "$device_type" "$runtime"
}

capture() {
  local udid="$1" bundle_id="$2" appearance="$3" destination="$4"
  local raw
  raw="$(mktemp -t screenshot).png"

  xcrun simctl ui "$udid" appearance "$appearance"
  xcrun simctl terminate "$udid" "$bundle_id" >/dev/null 2>&1 || true
  xcrun simctl launch "$udid" "$bundle_id" >/dev/null
  sleep "$launch_wait"
  xcrun simctl io "$udid" screenshot "$raw" >/dev/null 2>&1
  sips --resampleWidth "$width" -s format jpeg -s formatOptions "$quality" "$raw" --out "$destination" >/dev/null
  rm -f "$raw"
}

templates=("$@")
if [[ ${#templates[@]} -eq 0 ]]; then
  while IFS= read -r name; do templates+=("$name"); done < <(ls "$templates_dir")
fi

udid="$(resolve_simulator)"
xcrun simctl boot "$udid" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$udid" -b >/dev/null
xcrun simctl status_bar "$udid" override --time 9:41 --batteryState charged --batteryLevel 100 --cellularBars 4 --wifiBars 3
# Fixed locale so numbers and dates render the same on every machine.
xcrun simctl spawn "$udid" defaults write -g AppleLocale -string en_US
xcrun simctl spawn "$udid" defaults write -g AppleLanguages -array en
mkdir -p "$output_dir"

for template in "${templates[@]}"; do
  echo "==> $template"
  host_dir="$templates_dir/$template/App"
  bundle_id="com.example.$template"

  (cd "$host_dir" && xcodegen generate --quiet)
  xcodebuild build \
    -project "$host_dir/$template.xcodeproj" \
    -scheme "${template}Host" \
    -destination "platform=iOS Simulator,id=$udid" \
    -derivedDataPath "$derived_data" \
    -quiet

  xcrun simctl install "$udid" "$derived_data/Build/Products/Debug-iphonesimulator/$template.app"

  if [[ "$template" == "SocialMediaApp" ]]; then
    # Start signed in with the bundled demo account (see LocalAuthService).
    xcrun simctl spawn "$udid" defaults write "$bundle_id" SocialMediaApp.signedInEmail demo@example.com
  fi

  capture "$udid" "$bundle_id" light "$output_dir/$template-light.jpg"
  capture "$udid" "$bundle_id" dark "$output_dir/$template-dark.jpg"
  xcrun simctl terminate "$udid" "$bundle_id" >/dev/null 2>&1 || true
done

xcrun simctl ui "$udid" appearance light
echo "Screenshots written to $output_dir"
