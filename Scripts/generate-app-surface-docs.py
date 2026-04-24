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
EXAMPLES_HUB_PATH = REPO_ROOT / "Examples" / "README.md"
SCREENSHOTS_DIR = REPO_ROOT / "Documentation" / "Assets" / "AppScreenshots"


def load_catalog() -> list[dict[str, Any]]:
    return json.loads(CATALOG_PATH.read_text())


def code_link(path: str) -> str:
    return f"`{path}`"


def md_link(label: str, path: str) -> str:
    return f"[{label}]({path})"


def relative_doc_link(path: str) -> str:
    return "../../" + path if path.startswith("Templates/") or path.startswith("Examples/") else "../" + path.removeprefix("Documentation/")


def path_from_root(path: str) -> Path:
    return REPO_ROOT / path


def screenshot_relative_path(app_name: str) -> str:
    return f"../Assets/AppScreenshots/{app_name}.png"


def screenshot_exists(app_name: str) -> bool:
    return (SCREENSHOTS_DIR / f"{app_name}.png").exists()


def example_name(app: dict[str, Any]) -> str:
    example_path = app.get("example_path")
    if not example_path:
        raise ValueError(f"App {app['app']} has no example path")
    return Path(example_path).parent.name


def example_source_path(app: dict[str, Any]) -> str | None:
    example_path = app.get("example_path")
    if not example_path:
        return None

    example_dir = path_from_root(example_path).parent
    swift_files = sorted(path.name for path in example_dir.glob("*.swift"))
    if not swift_files:
        return None
    return swift_files[0]


def proof_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    example_path = app.get("example_path")
    lockfile_path = app.get("lockfile_path")
    has_screenshot = screenshot_exists(app_name)
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
    if has_screenshot:
        lines.append(f"- runtime screenshot is published: {md_link(screenshot_relative_path(app_name), screenshot_relative_path(app_name))}")
    if example_path:
        lines.append(f"- {code_link(example_path.removesuffix('/README.md'))} inspection route exists")
    lines.extend([
        "",
        "## Missing Proof",
        "",
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
    if not has_screenshot:
        lines.insert(lines.index("- demo clip not yet published"), "- runtime screenshot not yet published")
    return "\n".join(lines) + "\n"


def media_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    example_path = app.get("example_path")
    has_screenshot = screenshot_exists(app_name)
    media_status = "screenshot-published" if has_screenshot else "preview-published"
    lines: list[str] = [
        f"# {app_name} Media Surface",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        f"- App: `{app_name}`",
        f"- Lane: `{app['lane']}`",
        f"- Media status: `{media_status}`",
        "",
        "## Current Truth",
        "",
        f"- shareable gallery card is published: {md_link('../Assets/AppCards/' + app_name + '.svg', '../Assets/AppCards/' + app_name + '.svg')}",
        f"- preview board is published: {md_link('../Assets/AppPreviews/' + app_name + '.svg', '../Assets/AppPreviews/' + app_name + '.svg')}",
        "- demo clip is not yet published",
        "",
        "## What Exists Instead",
        "",
        f"- {md_link('App Proof Surface', f'../App-Proofs/{app_name}.md')}",
        f"- {md_link('Template Root README', relative_doc_link(app['readme_path']))}",
        f"- {md_link('Standalone Root Package', relative_doc_link(app['entry_path']))}",
    ]
    if has_screenshot:
        lines.insert(10, f"- runtime screenshot is published: {md_link(screenshot_relative_path(app_name), screenshot_relative_path(app_name))}")
    else:
        lines.insert(10, "- runtime screenshot is not yet published")
    if example_path:
        lines.append(f"- {md_link('Richer Example', relative_doc_link(example_path))}")
    lines.extend([
        "",
        "## Next Required Capture",
        "",
    ])
    lines.extend([f"1. {app['capture_targets'][0]}", f"2. {app['capture_targets'][1]}", f"3. {app['capture_targets'][2]}"])
    return "\n".join(lines) + "\n"


def template_root_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    lockfile_path = app.get("lockfile_path")
    example_path = app.get("example_path")
    has_screenshot = screenshot_exists(app_name)
    lines: list[str] = [
        f"# {app_name}",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        f"`{app_name}` is the standalone-root surface for the `{app['lane']}` lane inside `iOSAppTemplates`.",
        "",
        "## Today",
        "",
        f"- Label: `{app['label_today']}`",
        f"- Lane: `{app['lane']}`",
        f"- Entry: `{Path(app['entry_path']).name}`",
        f"- Product target: `{app['product_target']}`",
    ]
    if example_path:
        lines.append(f"- Richer example: `{Path(example_path).parent.as_posix()}`")
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
        "## Product Shape",
        "",
    ])
    lines.extend([f"- {item}" for item in app["product_shape"]])
    lines.extend([
        "",
        "## Current Proof",
        "",
    ])
    if lockfile_path:
        lines.append("- `Package.resolved` exists as the tracked dependency lockfile")
    else:
        lines.append("- No external dependency lockfile is required today")
    lines.extend([
        "- `swift package dump-package` passes",
        "- local `swift test` passes",
        f"- `xcodebuild -scheme {app_name} -destination 'generic/platform=iOS' build` passes",
        "- root repo `swift build -c release` passes",
        "- root repo `swift test` passes",
        "- canonical app proof page exists",
        "- canonical app media page exists",
    ])
    if example_path:
        lines.append("- richer example route exists")
    lines.extend([
        "",
        "## Missing Proof",
        "",
        "- demo clip",
        "- stable green hosted standalone iOS baseline on current `master`",
        "",
        "## Start Here",
        "",
        "```bash",
        "open Package.swift",
    ])
    if lockfile_path:
        lines.append("open Package.resolved")
    if example_path:
        lines.append(f"open ../../{example_path}")
    lines.extend([
        "```",
        "",
        "Repo-level proof:",
        "",
        "```bash",
        "cd ../..",
        "swift build",
        "swift test",
        "```",
        "",
        "Standalone generic iOS proof:",
        "",
        "```bash",
        f"xcodebuild -scheme {app_name} -destination 'generic/platform=iOS' build",
        "```",
        "",
        "## Canonical References",
        "",
        f"- {md_link('Proof Surface', f'../../Documentation/App-Proofs/{app_name}.md')}",
        f"- {md_link('Media Surface', f'../../Documentation/App-Media/{app_name}.md')}",
        f"- {md_link('Template Showcase', '../../Documentation/Template-Showcase.md')}",
        f"- {md_link('Proof Matrix', '../../Documentation/Proof-Matrix.md')}",
    ])
    if example_path:
        lines.append(f"- {md_link('Richer Example', f'../../{example_path}')}")
    return "\n".join(lines) + "\n"


def example_page(app: dict[str, Any]) -> str:
    example_path = app.get("example_path")
    if not example_path:
        raise ValueError(f"App {app['app']} has no example path")

    title = example_name(app)
    app_name = app["app"]
    source_path = example_source_path(app)
    lines: list[str] = [
        f"# {title}",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        f"`{title}` is the richer example surface for the `{app['lane']}` lane.",
        "",
        "## Product Shape",
        "",
    ]
    lines.extend([f"- {item}" for item in app["product_shape"][:4]])
    lines.extend([
        "",
        "## Best For / Not For",
        "",
        "### Best for",
        "",
        f"- teams that want a second inspection route beyond `{app['app']}`",
        f"- readers who want to inspect the `{app['product_target']}` flow in a more product-like format",
        "",
        "### Not for",
        "",
        "- teams expecting a separate runnable Xcode project",
        "- readers who expect published runtime screenshots or simulator media proof today",
        "",
        "## Current Truth",
        "",
        "- this example is an inspection surface, not a separate shipped app project",
        "- the canonical standalone package-entry path lives under `Templates/`",
        "- canonical package validation remains the root-level `swift build` and `swift test` flow",
        "",
        "## Start Here",
        "",
        "```bash",
    ])
    if source_path:
        lines.append(f"open {source_path}")
    lines.append(f"open ../../Templates/{app['app']}/Package.swift")
    lines.extend([
        "```",
        "",
        "Repo proof:",
        "",
        "```bash",
        "swift build",
        "swift test",
        "```",
        "",
        "## Canonical References",
        "",
        f"- {md_link(app_name + ' Proof', f'../../Documentation/App-Proofs/{app_name}.md')}",
        f"- {md_link(app_name + ' Media', f'../../Documentation/App-Media/{app_name}.md')}",
        f"- {md_link('Wave 1 Plan', '../../Documentation/Wave-1-Implementation-Plan.md')}",
    ])
    return "\n".join(lines) + "\n"


def examples_hub(catalog: list[dict[str, Any]]) -> str:
    richer_examples = [app for app in catalog if app.get("example_path")]
    lines: list[str] = [
        "# Examples Hub",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        "This folder is not a complete-app gallery. Its current role is:",
        "",
        "- source-level reference",
        "- lightweight onboarding example",
        f"- richer lane examples for `{len(richer_examples)}` tracked app packs",
        "",
        "## Canonical Example Router",
        "",
        "| Surface | Type | Use it for |",
        "| --- | --- | --- |",
        "| [BasicExample.swift](./BasicExample.swift) | single-file reference | inspect the package API quickly |",
        "| [BasicExample/BasicExample.swift](./BasicExample/BasicExample.swift) | small example shell | inspect minimal structure |",
        "| [QuickStartExample/QuickStartApp.swift](./QuickStartExample/QuickStartApp.swift) | onboarding entry | reach the fastest source-level start |",
    ]
    for app in richer_examples:
        title = example_name(app)
        lines.append(
            f"| [{title}](./{Path(app['example_path']).parent.name}/) | richer category example | inspect a more product-like {app['product_target'].lower()} flow |"
        )
    lines.extend([
        "",
        "## Important Truth",
        "",
        "- Not everything in this folder is a separate runnable Xcode project.",
        "- The most reliable standalone package-entry path today is under `Templates/`.",
        "- The most reliable repo validation path today is root `swift build` and `swift test`.",
        "",
        "## If You Want To Run Something",
        "",
        "### Package truth",
        "",
        "```bash",
        "swift build",
        "swift test",
        "```",
        "",
        "### Inspect standalone roots",
        "",
        "```bash",
    ])
    for app in catalog:
        lines.append(f"open ../Templates/{app['app']}/Package.swift")
    lines.extend([
        "```",
        "",
        "### Generator path",
        "",
        "```bash",
        "swift ../Scripts/TemplateGenerator.swift --interactive",
        "```",
        "",
        "## Related Docs",
        "",
        "- [../Documentation/Guides/QuickStart.md](../Documentation/Guides/QuickStart.md)",
        "- [../Documentation/Portfolio-Matrix.md](../Documentation/Portfolio-Matrix.md)",
        "- [../Documentation/Template-Showcase.md](../Documentation/Template-Showcase.md)",
        "- [../Documentation/TemplateGuide.md](../Documentation/TemplateGuide.md)",
        "- [../Documentation/Proof-Matrix.md](../Documentation/Proof-Matrix.md)",
        "- [../Documentation/App-Proofs/README.md](../Documentation/App-Proofs/README.md)",
        "- [../Documentation/Complete-App-Standard.md](../Documentation/Complete-App-Standard.md)",
        "- [../Documentation/Wave-1-Implementation-Plan.md](../Documentation/Wave-1-Implementation-Plan.md)",
    ])
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
    screenshot_count = sum(1 for app in catalog if screenshot_exists(app["app"]))
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
        f"- `{screenshot_count}` standalone roots already have published runtime screenshots",
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
        media_status = "screenshot-published" if screenshot_exists(app["app"]) else "preview-published"
        lines.append(f"| {app['app']} | {app['lane']} | `{media_status}` | [{app['app']}.md](./{app['app']}.md) |")
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
        "If an app is marked `screenshot-published`, it means:",
        "",
        "- a shareable gallery card exists",
        "- a preview board exists",
        "- at least one runtime screenshot is now published",
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
        ok &= write_if_changed(path_from_root(app["readme_path"]), template_root_page(app), args.check)
        if app.get("example_path"):
            ok &= write_if_changed(path_from_root(app["example_path"]), example_page(app), args.check)

    ok &= write_if_changed(PROOFS_DIR / "README.md", proof_router(catalog), args.check)
    ok &= write_if_changed(MEDIA_DIR / "README.md", media_router(catalog), args.check)
    ok &= write_if_changed(EXAMPLES_HUB_PATH, examples_hub(catalog), args.check)

    if not ok and args.check:
        print("Generated app surface docs are out of date.")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
