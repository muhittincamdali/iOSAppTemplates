#!/usr/bin/env python3

from __future__ import annotations

import json
from pathlib import Path


REPO_ROOT = Path(__file__).resolve().parent.parent
CATALOG_PATH = REPO_ROOT / "Documentation" / "app-surface-catalog.json"
OUTPUT_ROOT = REPO_ROOT / ".build" / "runtime-screenshot-hosts"
GENERATED_ROOT = OUTPUT_ROOT / "Generated"
CONFIG_ROOT = OUTPUT_ROOT / "Config"
PROJECT_SPEC_PATH = OUTPUT_ROOT / "project.json"

PROJECT_NAME = "iOSAppTemplatesRuntimeHosts"
RUNTIME_ENV_FLAG = "IOSAPPTEMPLATES_SCREENSHOT_MODE"

REMOTE_PACKAGES = {
    "Alamofire": {
        "url": "https://github.com/Alamofire/Alamofire.git",
        "from": "5.8.1",
    },
    "Firebase": {
        "url": "https://github.com/firebase/firebase-ios-sdk.git",
        "from": "10.18.0",
    },
    "Kingfisher": {
        "url": "https://github.com/onevcat/Kingfisher.git",
        "from": "7.9.1",
    },
    "Charts": {
        "url": "https://github.com/danielgindi/Charts.git",
        "from": "5.0.0",
    },
}


def load_catalog() -> list[dict[str, object]]:
    return json.loads(CATALOG_PATH.read_text())


def app_root(app_name: str) -> Path:
    return REPO_ROOT / "Templates" / app_name


def app_source_root(app_name: str) -> Path:
    return app_root(app_name) / "Sources"


def app_file_path(app_name: str) -> Path:
    return app_source_root(app_name) / app_name / f"{app_name}.swift"


def package_manifest_text(app_name: str) -> str:
    return (app_root(app_name) / "Package.swift").read_text()


def uses_inline_main(app_name: str) -> bool:
    return "@main" in app_file_path(app_name).read_text()


def bundle_id(name: str) -> str:
    return f"com.muhittincamdali.iOSAppTemplates.RuntimeHosts.{name}"


def target_dependency_target(name: str) -> dict[str, str]:
    return {"target": name}


def target_dependency_package(package_name: str, product_name: str | None = None) -> dict[str, str]:
    dependency: dict[str, str] = {"package": package_name}
    if product_name:
        dependency["product"] = product_name
    return dependency


def detect_package_dependencies(manifest_text: str) -> dict[str, list[dict[str, str]]]:
    package_dependencies: dict[str, list[dict[str, str]]] = {"app": [], "core": []}

    if "Alamofire" in manifest_text:
        package_dependencies["core"].append(target_dependency_package("Alamofire"))

    if "FirebaseAuth" in manifest_text or "firebase-ios-sdk" in manifest_text:
        package_dependencies["app"].extend(
            [
                target_dependency_package("Firebase", "FirebaseAuth"),
                target_dependency_package("Firebase", "FirebaseFirestore"),
                target_dependency_package("Firebase", "FirebaseStorage"),
                target_dependency_package("Firebase", "FirebaseAnalytics"),
            ]
        )

    if "Kingfisher" in manifest_text:
        package_dependencies["app"].append(target_dependency_package("Kingfisher"))

    if "DGCharts" in manifest_text or "Charts.git" in manifest_text:
        package_dependencies["app"].append(target_dependency_package("Charts", "DGCharts"))

    return package_dependencies


def used_remote_packages(package_dependencies: dict[str, list[dict[str, str]]]) -> set[str]:
    return {dependency["package"] for dependencies in package_dependencies.values() for dependency in dependencies}


def write_generated_main_file(app_name: str) -> str:
    relative_path = Path("Generated") / f"{app_name}RuntimeMain.swift"
    absolute_path = OUTPUT_ROOT / relative_path
    absolute_path.write_text(
        "\n".join(
            [
                "import SwiftUI",
                f"import {app_name}",
                "",
                "@main",
                f"struct {app_name}Runtime: App {{",
                "    var body: some Scene {",
                f"        {app_name}Shell().body",
                "    }",
                "}",
                "",
            ]
        )
    )
    return relative_path.as_posix()


def runtime_app_target(
    app_name: str,
    source_path: str,
    dependencies: list[dict[str, str]],
) -> dict[str, object]:
    return {
        "type": "application",
        "platform": "iOS",
        "deploymentTarget": "18.0",
        "sources": [{"path": source_path}],
        "settings": {
            "base": {
                "PRODUCT_NAME": f"{app_name}Runtime",
                "INFOPLIST_FILE": "Config/RuntimeHost-Info.plist",
                "PRODUCT_BUNDLE_IDENTIFIER": bundle_id(f"{app_name}Runtime"),
                "GENERATE_INFOPLIST_FILE": "NO",
                "TARGETED_DEVICE_FAMILY": "1",
                "SUPPORTS_MACCATALYST": "NO",
            }
        },
        "dependencies": dependencies,
    }


def framework_target(
    target_name: str,
    source_path: Path,
    dependencies: list[dict[str, str]],
) -> dict[str, object]:
    return {
        "type": "framework",
        "platform": "iOS",
        "deploymentTarget": "18.0",
        "sources": [{"path": source_path.as_posix()}],
        "settings": {
            "base": {
                "GENERATE_INFOPLIST_FILE": "YES",
                "PRODUCT_BUNDLE_IDENTIFIER": bundle_id(target_name),
            }
        },
        "dependencies": dependencies,
    }


def create_project_spec() -> dict[str, object]:
    targets: dict[str, object] = {}
    all_used_packages: set[str] = set()

    for app in load_catalog():
        app_name = str(app["app"])
        manifest_text = package_manifest_text(app_name)
        package_deps = detect_package_dependencies(manifest_text)
        all_used_packages.update(used_remote_packages(package_deps))

        core_target_name = f"{app_name}Core"
        ui_target_name = f"{app_name}UI"

        targets[core_target_name] = framework_target(
            core_target_name,
            app_source_root(app_name) / core_target_name,
            package_deps["core"],
        )

        targets[ui_target_name] = framework_target(
            ui_target_name,
            app_source_root(app_name) / ui_target_name,
            [target_dependency_target(core_target_name)],
        )

        app_source_path = app_source_root(app_name) / app_name
        app_target_dependencies = [
            target_dependency_target(ui_target_name),
            target_dependency_target(core_target_name),
            *package_deps["app"],
        ]

        if uses_inline_main(app_name):
            targets[f"{app_name}Runtime"] = runtime_app_target(
                app_name,
                app_file_path(app_name).as_posix(),
                app_target_dependencies,
            )
            continue

        targets[app_name] = framework_target(
            app_name,
            app_source_path,
            app_target_dependencies,
        )

        generated_main_path = write_generated_main_file(app_name)
        targets[f"{app_name}Runtime"] = runtime_app_target(
            app_name,
            generated_main_path,
            [
                target_dependency_target(app_name),
                target_dependency_target(ui_target_name),
                target_dependency_target(core_target_name),
            ],
        )

    packages = {name: REMOTE_PACKAGES[name] for name in sorted(all_used_packages)}

    return {
        "name": PROJECT_NAME,
        "options": {
            "deploymentTarget": {"iOS": "18.0"},
            "transitivelyLinkDependencies": False,
            "createIntermediateGroups": True,
            "developmentLanguage": "en",
        },
        "settings": {
            "base": {
                "CODE_SIGNING_ALLOWED": "NO",
                "ENABLE_PREVIEWS": "NO",
                "SWIFT_VERSION": "6.0",
            }
        },
        "packages": packages,
        "targets": targets,
    }


def write_runtime_host_info_plist() -> None:
    (CONFIG_ROOT / "RuntimeHost-Info.plist").write_text(
        """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>UILaunchScreen</key>
    <dict/>
</dict>
</plist>
"""
    )


def main() -> None:
    GENERATED_ROOT.mkdir(parents=True, exist_ok=True)
    CONFIG_ROOT.mkdir(parents=True, exist_ok=True)
    write_runtime_host_info_plist()
    PROJECT_SPEC_PATH.write_text(json.dumps(create_project_spec(), indent=2) + "\n")
    print(f"Generated runtime screenshot hosts at {PROJECT_SPEC_PATH}")
    print(f"Runtime flag: {RUNTIME_ENV_FLAG}=1")


if __name__ == "__main__":
    main()
