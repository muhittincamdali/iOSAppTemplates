#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
scratch_root="$(mktemp -d "${TMPDIR:-/tmp}/iosapptemplates-generator-smoke.XXXXXX")"
generated_project_dir="$scratch_root/FinanceStarter"

cleanup() {
  rm -rf "$scratch_root"
}

trap cleanup EXIT

cd "$repo_root"

swift Scripts/TemplateGenerator.swift --list >/dev/null
swift Scripts/TemplateGenerator.swift --template finance --name "FinanceStarter" --output "$scratch_root" >/dev/null

cd "$generated_project_dir"

swift build >/dev/null
swift test >/dev/null

echo "Template generator smoke validation passed."
