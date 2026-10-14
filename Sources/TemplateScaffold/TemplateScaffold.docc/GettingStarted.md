# Getting Started

Generate a project, run its tests and open it in Xcode.

## Overview

You need macOS 14 or later, Xcode with a Swift 6 toolchain (the repository is built and
tested with Xcode 27) and, to generate the host app project,
[XcodeGen](https://github.com/yonaskolb/XcodeGen).

### List the templates

```bash
git clone https://github.com/muhittincamdali/iOSAppTemplates.git
cd iOSAppTemplates
swift run create-ios-app list
```

Each line shows the identifier you pass to `--template`, the display name and the tabs
of the app's root `TabView`.

### Create a project

```bash
swift run create-ios-app new MyShop --template ecommerce --output ~/Developer
```

The name must be a valid Swift identifier made of ASCII letters, digits and underscores,
must start with a letter and must not be a Swift keyword or a framework name such as
`App` or `SwiftUI`. The tool refuses to overwrite an existing directory.

The tool looks for the templates in `--templates-dir`, then in `./Templates`, then next to
the checkout it was built from.

### Run the tests

The generated package targets iOS 18, so tests run in the simulator:

```bash
cd ~/Developer/MyShop
xcodebuild test -scheme MyShop -destination 'platform=iOS Simulator,name=iPhone 17'
```

`iPhone 17` is an example; use any simulator that `xcrun simctl list devices available` lists.

### Run the app

```bash
cd App
xcodegen generate
open MyShop.xcodeproj
```

The host target contains a single file that calls `MyShopShell.main()`. All screens and
state live in the `MyShop` package, so you can also add the package to an app project of
your own instead; see <doc:AddingATemplateToAnApp>.
