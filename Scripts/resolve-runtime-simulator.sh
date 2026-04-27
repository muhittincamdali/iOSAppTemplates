#!/usr/bin/env bash

set -euo pipefail

simulator_name="${IOSAPPTEMPLATES_SIMULATOR_NAME:-iOSAppTemplates-GitHub-iPhone17Pro}"
device_type_id="${IOSAPPTEMPLATES_SIMULATOR_DEVICE_TYPE:-com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro}"

runtime_id="${IOSAPPTEMPLATES_SIMULATOR_RUNTIME:-$(
  xcrun simctl list runtimes available -j \
    | python3 -c 'import json, sys
data = json.load(sys.stdin)
runtimes = [runtime for runtime in data["runtimes"] if runtime.get("isAvailable") and runtime.get("identifier", "").startswith("com.apple.CoreSimulator.SimRuntime.iOS-")]
if not runtimes:
    raise SystemExit("No available iOS simulator runtime found")
def sort_key(runtime):
    version = str(runtime.get("version", "0"))
    return tuple(int(part) for part in version.split(".") if part.isdigit())
selected = sorted(runtimes, key=sort_key, reverse=True)[0]
print(selected["identifier"])'
)}"

existing_simulator_id="$(
  xcrun simctl list devices -j \
    | python3 -c 'import json, sys
target_name = sys.argv[1]
data = json.load(sys.stdin)
matches = []
for entries in data["devices"].values():
    for device in entries:
        if device["name"] == target_name:
            matches.append(device)
if matches:
    matches.sort(key=lambda device: device.get("state") != "Booted")
    print(matches[0]["udid"])
    raise SystemExit(0)
raise SystemExit(1)' "$simulator_name"
)" || true

if [[ -z "${existing_simulator_id}" ]]; then
  echo "Creating dedicated simulator: ${simulator_name}" >&2
  existing_simulator_id="$(xcrun simctl create "$simulator_name" "$device_type_id" "$runtime_id")"
fi

echo "$existing_simulator_id"
