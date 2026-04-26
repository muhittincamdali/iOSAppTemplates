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
SCENARIOS_DIR = REPO_ROOT / "Documentation" / "App-Scenarios"
EXAMPLES_HUB_PATH = REPO_ROOT / "Examples" / "README.md"
SCREENSHOTS_DIR = REPO_ROOT / "Documentation" / "Assets" / "AppScreenshots"
DEMO_CLIPS_DIR = REPO_ROOT / "Documentation" / "Assets" / "AppDemoClips"
SCENARIO_SHOTS_DIR = REPO_ROOT / "Documentation" / "Assets" / "AppScenarioShots"
SCENARIO_BOARDS_DIR = REPO_ROOT / "Documentation" / "Assets" / "AppScenarioBoards"
APP_GALLERY_PATH = REPO_ROOT / "Documentation" / "App-Gallery.md"


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


def demo_clip_relative_path(app_name: str) -> str:
    return f"../Assets/AppDemoClips/{app_name}.mp4"


def demo_clip_exists(app_name: str) -> bool:
    return (DEMO_CLIPS_DIR / f"{app_name}.mp4").exists()


def scenario_launch_relative_path(app_name: str) -> str:
    return f"../Assets/AppScenarioShots/{app_name}-launch.png"


def scenario_ready_relative_path(app_name: str) -> str:
    return f"../Assets/AppScenarioShots/{app_name}-ready.png"


def scenario_launch_exists(app_name: str) -> bool:
    return (SCENARIO_SHOTS_DIR / f"{app_name}-launch.png").exists()


def scenario_ready_exists(app_name: str) -> bool:
    return (SCENARIO_SHOTS_DIR / f"{app_name}-ready.png").exists()


def scenario_pair_exists(app_name: str) -> bool:
    return scenario_launch_exists(app_name) and scenario_ready_exists(app_name)


def scenario_board_relative_path(app_name: str) -> str:
    return f"../Assets/AppScenarioBoards/{app_name}.svg"


def scenario_board_exists(app_name: str) -> bool:
    return (SCENARIO_BOARDS_DIR / f"{app_name}.svg").exists()


def scenario_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    has_screenshot = screenshot_exists(app_name)
    has_demo_clip = demo_clip_exists(app_name)
    has_scenario_pair = scenario_pair_exists(app_name)
    lines: list[str] = [
        f"# {app_name} Runtime Scenario",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        f"- App: `{app_name}`",
        f"- Lane: `{app['lane']}`",
        f"- Product target: `{app['product_target']}`",
        "",
        "## Scenario Truth",
        "",
        "- this is a runtime progression page, not a complete-app claim",
        "- the sequence below only proves launch, ready, and first-screen runtime states",
        "- deeper interaction flows still require separate automation work",
        "",
        "## Published Runtime Progression",
        "",
    ]
    if has_scenario_pair:
        lines.extend([
            "### Scenario Board",
            "",
            f"![{app_name} scenario board]({scenario_board_relative_path(app_name)})",
            "",
            "### Launch Frame",
            "",
            f"![{app_name} launch]({scenario_launch_relative_path(app_name)})",
            "",
            "### Ready Frame",
            "",
            f"![{app_name} ready]({scenario_ready_relative_path(app_name)})",
            "",
        ])
    if has_screenshot:
        lines.extend([
            "### Runtime Screenshot",
            "",
            f"![{app_name} screenshot]({screenshot_relative_path(app_name)})",
            "",
        ])
    if has_demo_clip:
        lines.extend([
            "### Demo Clip",
            "",
            f"- {md_link(demo_clip_relative_path(app_name), demo_clip_relative_path(app_name))}",
            "",
        ])
    lines.extend([
        "## Canonical References",
        "",
        f"- {md_link('App Proof Surface', f'../App-Proofs/{app_name}.md')}",
        f"- {md_link('App Media Surface', f'../App-Media/{app_name}.md')}",
        f"- {md_link('App Gallery', '../App-Gallery.md')}",
        f"- {md_link('Scenario Router', '../App-Scenarios/README.md')}",
    ])
    return "\n".join(lines) + "\n"


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
    has_demo_clip = demo_clip_exists(app_name)
    has_scenario_pair = scenario_pair_exists(app_name)
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
        f"- local simulator runtime launch proof is tracked via `bash Scripts/validate-runtime-app-launches.sh {app_name}`",
        "- the hosted standalone iOS proof workflow is active; check live GitHub status on `master`",
        "- root repo `swift build -c release` passes",
        "- root repo `swift test` passes",
    ])
    if has_screenshot:
        lines.append(f"- runtime screenshot is published: {md_link(screenshot_relative_path(app_name), screenshot_relative_path(app_name))}")
    if has_demo_clip:
        lines.append(f"- demo clip is published: {md_link(demo_clip_relative_path(app_name), demo_clip_relative_path(app_name))}")
    if has_scenario_pair:
        lines.append(
            "- launch-to-ready scenario frames are published: "
            f"{md_link('launch', scenario_launch_relative_path(app_name))} / "
            f"{md_link('ready', scenario_ready_relative_path(app_name))}"
        )
    if example_path:
        lines.append(f"- {code_link(example_path.removesuffix('/README.md'))} inspection route exists")
    lines.extend([
        "",
        "## Missing Proof",
        "",
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
    insert_at = lines.index("- stable green hosted standalone iOS baseline should be checked on current `master`")
    if not has_demo_clip:
        lines.insert(insert_at, "- demo clip not yet published")
        insert_at += 1
    if not has_screenshot:
        lines.insert(insert_at, "- runtime screenshot not yet published")
    return "\n".join(lines) + "\n"


def media_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    example_path = app.get("example_path")
    has_screenshot = screenshot_exists(app_name)
    has_demo_clip = demo_clip_exists(app_name)
    has_scenario_pair = scenario_pair_exists(app_name)
    media_status = "scenario-published" if has_scenario_pair else "demo-published" if has_demo_clip else "screenshot-published" if has_screenshot else "preview-published"
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
    if has_demo_clip:
        lines.insert(11, f"- demo clip is published: {md_link(demo_clip_relative_path(app_name), demo_clip_relative_path(app_name))}")
    else:
        lines.insert(11, "- demo clip is not yet published")
    if has_scenario_pair:
        lines.insert(
            12,
            "- launch-to-ready scenario frames are published: "
            f"{md_link('launch', scenario_launch_relative_path(app_name))} / "
            f"{md_link('ready', scenario_ready_relative_path(app_name))}",
        )
    else:
        lines.insert(12, "- launch-to-ready scenario frames are not yet published")
    if example_path:
        lines.append(f"- {md_link('Richer Example', relative_doc_link(example_path))}")
    lines.extend([
        "",
        "## Next Required Capture",
        "",
    ])
    lines.extend([f"1. {app['capture_targets'][0]}", f"2. {app['capture_targets'][1]}", f"3. {app['capture_targets'][2]}"])
    lines.extend([
        "",
        "## Runtime Scenario Route",
        "",
        f"- {md_link('Runtime Scenario Page', f'../App-Scenarios/{app_name}.md')}",
    ])
    return "\n".join(lines) + "\n"


def template_root_page(app: dict[str, Any]) -> str:
    app_name = app["app"]
    lockfile_path = app.get("lockfile_path")
    example_path = app.get("example_path")
    has_screenshot = screenshot_exists(app_name)
    has_demo_clip = demo_clip_exists(app_name)
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
        f"- `bash Scripts/validate-runtime-app-launches.sh {app_name}` passes locally",
        "- root repo `swift build -c release` passes",
        "- root repo `swift test` passes",
        "- canonical app proof page exists",
        "- canonical app media page exists",
    ])
    if has_screenshot:
        lines.append("- runtime screenshot is published")
    if has_demo_clip:
        lines.append("- demo clip is published")
    if example_path:
        lines.append("- richer example route exists")
    lines.extend([
        "",
        "## Missing Proof",
        "",
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
    if not has_demo_clip:
        lines.insert(lines.index("- stable green hosted standalone iOS baseline on current `master`"), "- demo clip")
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
        "- readers who expect deeper interactive runtime flows than the current launch-to-ready scenario set",
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
        f"- {md_link('../App-Scenarios/README.md', '../App-Scenarios/README.md')}",
        f"- {md_link('../Template-Showcase.md', '../Template-Showcase.md')}",
        f"- {md_link('../Proof-Matrix.md', '../Proof-Matrix.md')}",
        f"- {md_link('../Portfolio-Matrix.md', '../Portfolio-Matrix.md')}",
        f"- {md_link('../../.github/workflows/standalone-ios-proof.yml', '../../.github/workflows/standalone-ios-proof.yml')}",
    ])
    return "\n".join(lines) + "\n"


def scenario_router(catalog: list[dict[str, Any]]) -> str:
    scenario_count = sum(1 for app in catalog if scenario_pair_exists(app["app"]))
    lines: list[str] = [
        "# Runtime Scenario Router",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        "This directory is the canonical runtime progression router for the standalone app roots inside `iOSAppTemplates`.",
        "",
        "Current truth:",
        "",
        f"- `{scenario_count}` standalone roots have published launch-to-ready scenario frame pairs",
        f"- `{sum(1 for app in catalog if scenario_board_exists(app['app']))}` standalone roots have published shareable scenario boards",
        f"- `{sum(1 for app in catalog if screenshot_exists(app['app']))}` standalone roots have published runtime screenshots",
        f"- `{sum(1 for app in catalog if demo_clip_exists(app['app']))}` standalone roots have published demo clips",
        "- this surface tracks runtime progression, not deep interaction parity",
        "",
        "## Current Router",
        "",
        "| App | Lane | Scenario | Board | Surface |",
        "| --- | --- | --- | --- | --- |",
    ]
    for app in catalog:
        status = "published" if scenario_pair_exists(app["app"]) else "missing"
        board_cell = f"[board]({scenario_board_relative_path(app['app'])})" if scenario_board_exists(app["app"]) else "missing"
        lines.append(f"| {app['app']} | {app['lane']} | `{status}` | {board_cell} | [{app['app']}.md](./{app['app']}.md) |")
    lines.extend([
        "",
        "## Rule",
        "",
        "A runtime scenario page does not prove complete interaction depth.",
        "",
        "It currently proves only:",
        "",
        "- launch frame",
        "- ready frame",
        "- first-screen screenshot",
        "- short runtime clip",
        "",
        "## Related Surfaces",
        "",
        f"- {md_link('../App-Media/README.md', '../App-Media/README.md')}",
        f"- {md_link('../App-Proofs/README.md', '../App-Proofs/README.md')}",
        f"- {md_link('../App-Gallery.md', '../App-Gallery.md')}",
        f"- {md_link('../Proof-Matrix.md', '../Proof-Matrix.md')}",
    ])
    return "\n".join(lines) + "\n"


def media_router(catalog: list[dict[str, Any]]) -> str:
    screenshot_count = sum(1 for app in catalog if screenshot_exists(app["app"]))
    demo_clip_count = sum(1 for app in catalog if demo_clip_exists(app["app"]))
    scenario_count = sum(1 for app in catalog if scenario_pair_exists(app["app"]))
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
        f"- `{demo_clip_count}` standalone roots already have published demo clips",
        f"- `{scenario_count}` standalone roots already have published launch-to-ready scenario frame pairs",
        "- this surface separates visual layers instead of hiding the runtime scenario gap",
        "",
        "This surface exists to:",
        "",
        "- show screenshot, demo, and scenario status truthfully",
        "- provide a single canonical route for future capture batches",
        "- keep proof pages and media pages separate",
        "",
        "## Current Router",
        "",
        "| App | Lane | Media Status | Surface |",
        "| --- | --- | --- | --- |",
    ]
    for app in catalog:
        media_status = "scenario-published" if scenario_pair_exists(app["app"]) else "demo-published" if demo_clip_exists(app["app"]) else "screenshot-published" if screenshot_exists(app["app"]) else "preview-published"
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
        "If an app is marked `demo-published`, it means:",
        "",
        "- a shareable gallery card exists",
        "- a preview board exists",
        "- at least one runtime screenshot is now published",
        "- at least one short runtime demo clip is now published",
        "- launch-to-ready scenario frames may still be missing",
        "",
        "If an app is marked `scenario-published`, it means:",
        "",
        "- a shareable gallery card exists",
        "- a preview board exists",
        "- at least one runtime screenshot is now published",
        "- at least one short runtime demo clip is now published",
        "- launch and ready runtime scenario frames are now published",
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


def app_gallery_page(catalog: list[dict[str, Any]]) -> str:
    screenshot_count = sum(1 for app in catalog if screenshot_exists(app["app"]))
    demo_clip_count = sum(1 for app in catalog if demo_clip_exists(app["app"]))
    scenario_count = sum(1 for app in catalog if scenario_pair_exists(app["app"]))
    lines: list[str] = [
        "# App Gallery",
        "",
        "Generated from `Documentation/app-surface-catalog.json`.",
        "",
        "This page is the canonical visual router for `iOSAppTemplates`.",
        "",
        "Current truth:",
        "",
        f"- `{len(catalog)}` apps have published shareable gallery-card assets",
        f"- `{len(catalog)}` apps have published preview-board assets",
        f"- `{screenshot_count}` apps already have published runtime screenshots",
        f"- `{demo_clip_count}` apps already have published runtime demo clips",
        f"- `{scenario_count}` apps already have published launch-to-ready scenario frame pairs",
        "- this surface provides visual routing; it does not make a complete-app parity claim",
        "",
        "## Current Visual Router",
        "",
        "| App | Lane | Card | Preview | Screenshot | Clip | Scenario | Proof | Media |",
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for app in catalog:
        app_name = app["app"]
        screenshot_cell = f"[shot](./Assets/AppScreenshots/{app_name}.png)" if screenshot_exists(app_name) else "pending"
        clip_cell = f"[clip](./Assets/AppDemoClips/{app_name}.mp4)" if demo_clip_exists(app_name) else "pending"
        scenario_cell = (
            f"[launch](./Assets/AppScenarioShots/{app_name}-launch.png) / [ready](./Assets/AppScenarioShots/{app_name}-ready.png)"
            if scenario_pair_exists(app_name)
            else "pending"
        )
        lines.append(
            f"| {app_name} | {app['lane']} | [card](./Assets/AppCards/{app_name}.svg) | "
            f"[preview](./Assets/AppPreviews/{app_name}.svg) | {screenshot_cell} | {clip_cell} | {scenario_cell} | "
            f"[proof](./App-Proofs/{app_name}.md) | [media](./App-Media/{app_name}.md) |"
        )
    lines.extend([
        "",
        "## Rule",
        "",
        "A published gallery card does not make an app `complete`.",
        "",
        "This page only proves these things:",
        "",
        "- a shareable visual card is published",
        "- a preview board is published",
        "- runtime screenshot, demo clip, and scenario-frame status are routed honestly",
        "- the proof and media routers are canonical",
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
    SCENARIOS_DIR.mkdir(parents=True, exist_ok=True)
    ok = True

    for app in catalog:
        ok &= write_if_changed(PROOFS_DIR / f"{app['app']}.md", proof_page(app), args.check)
        ok &= write_if_changed(MEDIA_DIR / f"{app['app']}.md", media_page(app), args.check)
        ok &= write_if_changed(SCENARIOS_DIR / f"{app['app']}.md", scenario_page(app), args.check)
        ok &= write_if_changed(path_from_root(app["readme_path"]), template_root_page(app), args.check)
        if app.get("example_path"):
            ok &= write_if_changed(path_from_root(app["example_path"]), example_page(app), args.check)

    ok &= write_if_changed(PROOFS_DIR / "README.md", proof_router(catalog), args.check)
    ok &= write_if_changed(MEDIA_DIR / "README.md", media_router(catalog), args.check)
    ok &= write_if_changed(SCENARIOS_DIR / "README.md", scenario_router(catalog), args.check)
    ok &= write_if_changed(EXAMPLES_HUB_PATH, examples_hub(catalog), args.check)
    ok &= write_if_changed(APP_GALLERY_PATH, app_gallery_page(catalog), args.check)

    if not ok and args.check:
        print("Generated app surface docs are out of date.")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
