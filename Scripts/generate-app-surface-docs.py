#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parent.parent
CATALOG_PATH = REPO_ROOT / "Documentation" / "app-surface-catalog.json"
PROOFS_DIR = REPO_ROOT / "Documentation" / "App-Proofs"
MEDIA_DIR = REPO_ROOT / "Documentation" / "App-Media"


def load_catalog() -> list[dict[str, Any]]:
    return json.loads(CATALOG_PATH.read_text())


def code_link(path: str) -> str:
    return f"`{path}`"


def md_link(label: str, path: str) -> str:
    return f"[{label}]({path})"


def relative_doc_link(path: str) -> str:
    return "../../" + path if path.startswith("Templates/") or path.startswith("Examples/") else "../" + path.removeprefix("Documentation/")


def proof_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    example_path = app.get("example_path")
    lockfile_path = app.get("lockfile_path")
    lines: list[str] = [
        f"# {app_name} Proof Surface",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        "## Product Summary",
        "",
        f"- Lane: `{app['lane']}`",
        f"- Label today: `{app['label_today']}`",
        f"- Entry path: `{app['entry_path']}`",
    ]
    if example_path:
        lines.append(f"- Extra route: `{example_path.removesuffix('/README.md')}`")
    lines.append(f"- Product target: `{app['product_target']}`")
    lines.extend([
        "",
        "## Best For / Not For",
        "",
        "### Best for",
        "",
    ])
    lines.extend([f"- {item}" for item in app["best_for"]])
    lines.extend([
        "",
        "### Not for",
        "",
    ])
    lines.extend([f"- {item}" for item in app["not_for"]])
    lines.extend([
        "",
        "## Product Shape Today",
        "",
    ])
    lines.extend([f"- {item}" for item in app["product_shape"]])
    lines.extend([
        "",
        "## Current Proof",
        "",
        "- standalone root package exists",
        "- template-root README exists",
        f"- {code_link(app['entry_path'])} exists",
    ])
    if lockfile_path:
        lines.append(f"- {code_link(lockfile_path)} exists as the tracked dependency lockfile")
    else:
        lines.append("- no external dependency lockfile is required today")
    lines.extend([
        f"- local generic iOS build proof is tracked via `xcodebuild -scheme {app_name} -destination 'generic/platform=iOS' build`",
        "- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`",
        "- root repo `swift build -c release` passes",
        "- root repo `swift test` passes",
    ])
    if example_path:
        lines.append(f"- {code_link(example_path.removesuffix('/README.md'))} inspection route exists")
    lines.extend([
        "",
        "## Missing Proof",
        "",
        "- runtime screenshot not yet published",
        "- demo clip not yet published",
        "- stable green hosted standalone iOS baseline should be checked on current `master`",
        "",
        "## Start Path",
        "",
        "```bash",
        f"open {app['entry_path']}",
    ])
    if lockfile_path:
        lines.append(f"open {lockfile_path}")
    if example_path:
        lines.append(f"open {example_path}")
    lines.append(f"xcodebuild -scheme {app_name} -destination 'generic/platform=iOS' build")
    lines.extend([
        "```",
        "",
        "Then validate the root package:",
        "",
        "```bash",
        "swift build -c release",
        "swift test",
        "```",
        "",
        "## Canonical References",
        "",
        f"- {md_link('Template Root README', relative_doc_link(app['readme_path']))}",
    ])
    if example_path:
        lines.append(f"- {md_link('Richer Example', relative_doc_link(example_path))}")
    lines.extend([
        f"- {md_link('App Media Surface', f'../App-Media/{app_name}.md')}",
        f"- {md_link('Template Showcase', '../Template-Showcase.md')}",
        f"- {md_link('Proof Matrix', '../Proof-Matrix.md')}",
        f"- {md_link('Portfolio Matrix', '../Portfolio-Matrix.md')}",
    ])
    return "\n".join(lines) + "\n"


def media_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    example_path = app.get("example_path")
    lines: list[str] = [
        f"# {app_name} Media Surface",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        f"- App: `{app_name}`",
        f"- Lane: `{app['lane']}`",
        "- Media status: `preview-published`",
        "",
        "## Current Truth",
        "",
        f"- shareable gallery card is published: {md_link('../Assets/AppCards/' + app_name + '.svg', '../Assets/AppCards/' + app_name + '.svg')}",
        f"- preview board is published: {md_link('../Assets/AppPreviews/' + app_name + '.svg', '../Assets/AppPreviews/' + app_name + '.svg')}",
        "- runtime screenshot is not yet published",
        "- demo clip is not yet published",
        "",
        "## What Exists Instead",
        "",
        f"- {md_link('App Proof Surface', f'../App-Proofs/{app_name}.md')}",
        f"- {md_link('Template Root README', relative_doc_link(app['readme_path']))}",
        f"- {md_link('Standalone Root Package', relative_doc_link(app['entry_path']))}",
    ]
    if example_path:
        lines.append(f"- {md_link('Richer Example', relative_doc_link(example_path))}")
    lines.extend([
        "",
        "## Next Required Capture",
        "",
    ])
    lines.extend([f"1. {app['capture_targets'][0]}", f"2. {app['capture_targets'][1]}", f"3. {app['capture_targets'][2]}"])
    return "\n".join(lines) + "\n"


def proof_router(catalog: list[dict[str, Any]]) -> str:
    richer_examples = sum(1 for app in catalog if app.get("example_path"))
    lines: list[str] = [
        "# App Proof Surfaces",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        "This directory is the canonical proof router for the standalone app roots inside `iOSAppTemplates`.",
        "",
        "Current proof envelope:",
        "",
        f"- `{len(catalog)}` standalone app roots have canonical proof pages",
        f"- local generic iOS build proof exists for `{len(catalog)}` standalone roots",
        f"- the hosted standalone iOS proof workflow is active for the same `{len(catalog)}` roots",
        f"- `{richer_examples}` app packs currently also have a richer example route",
        "",
        "These pages exist to:",
        "",
        "- help users make a `best for / not for` decision",
        "- clarify current product shape",
        "- state today’s proof plainly",
        "- keep missing proof layers visible",
        "",
        "## Current App Proof Router",
        "",
        "| App | Lane | Today | Proof Surface |",
        "| --- | --- | --- | --- |",
    ]
    for app in catalog:
        lines.append(f"| {app['app']} | {app['lane']} | {app['label_today']} | [{app['app']}.md](./{app['app']}.md) |")
    lines.extend([
        "",
        "## Rule",
        "",
        "A proof surface alone does not make an app a `Complete App`.",
        "",
        "Correct labels for these apps today:",
        "",
        "- `Standalone Root`",
        "- `App-shell proof surface`",
        "",
        "Canonical complete-app standard:",
        f"- {md_link('../Complete-App-Standard.md', '../Complete-App-Standard.md')}",
        "",
        "## Related Surfaces",
        "",
        f"- {md_link('../App-Media/README.md', '../App-Media/README.md')}",
        f"- {md_link('../Template-Showcase.md', '../Template-Showcase.md')}",
        f"- {md_link('../Proof-Matrix.md', '../Proof-Matrix.md')}",
        f"- {md_link('../Portfolio-Matrix.md', '../Portfolio-Matrix.md')}",
        f"- {md_link('../../.github/workflows/standalone-ios-proof.yml', '../../.github/workflows/standalone-ios-proof.yml')}",
    ])
    return "\n".join(lines) + "\n"


def media_router(catalog: list[dict[str, Any]]) -> str:
    lines: list[str] = [
        "# App Media Surfaces",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        "This directory is the canonical media router for the standalone app roots inside `iOSAppTemplates`.",
        "",
        "Current truth:",
        "",
        f"- `{len(catalog)}` standalone roots have published shareable gallery cards",
        f"- `{len(catalog)}` standalone roots have published preview boards",
        "- canonical runtime screenshots are still missing",
        "- demo clips are still missing",
        "- this surface separates visual layers instead of hiding the screenshot and demo gap",
        "",
        "This surface exists to:",
        "",
        "- show screenshot and demo status truthfully",
        "- provide a single canonical route for future capture batches",
        "- keep proof pages and media pages separate",
        "",
        "## Current Router",
        "",
        "| App | Lane | Media Status | Surface |",
        "| --- | --- | --- | --- |",
    ]
    for app in catalog:
        lines.append(f"| {app['app']} | {app['lane']} | `preview-published` | [{app['app']}.md](./{app['app']}.md) |")
    lines.extend([
        "",
        "## Rule",
        "",
        "A media surface alone does not make an app `complete`.",
        "",
        "If an app is marked `preview-published`, it means:",
        "",
        "- a shareable gallery card exists",
        "- a preview board exists",
        "- a real screenshot may still be missing",
        "- a demo clip may still be missing",
        "",
        "## Related Surfaces",
        "",
        f"- {md_link('../App-Gallery.md', '../App-Gallery.md')}",
        f"- {md_link('../App-Proofs/README.md', '../App-Proofs/README.md')}",
        f"- {md_link('../Proof-Matrix.md', '../Proof-Matrix.md')}",
        f"- {md_link('../Template-Showcase.md', '../Template-Showcase.md')}",
        f"- {md_link('../Complete-App-Standard.md', '../Complete-App-Standard.md')}",
    ])
    return "\n".join(lines) + "\n"


def write_if_changed(path: Path, content: str, check: bool) -> bool:
    existing = path.read_text() if path.exists() else None
    changed = existing != content
    if changed and check:
        return False
    if changed:
        path.write_text(content)
    return True


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    catalog = load_catalog()
    ok = True

    for app in catalog:
        ok &= write_if_changed(PROOFS_DIR / f"{app['app']}.md", proof_page(app), args.check)
        ok &= write_if_changed(MEDIA_DIR / f"{app['app']}.md", media_page(app), args.check)

    ok &= write_if_changed(PROOFS_DIR / "README.md", proof_router(catalog), args.check)
    ok &= write_if_changed(MEDIA_DIR / "README.md", media_router(catalog), args.check)

    if not ok and args.check:
        print("Generated app surface docs are out of date.")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
