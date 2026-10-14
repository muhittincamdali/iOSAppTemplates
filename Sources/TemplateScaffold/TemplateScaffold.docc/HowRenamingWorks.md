# How Renaming Works

The rules ``Scaffolder`` follows when it copies a template.

## Overview

Every template uses its directory name as a prefix for everything that has to change:
the package name, the module name, the test target, the `AppShell` type, the
XcodeGen project and the bundle identifier. Renaming is therefore a single text
substitution, applied to file contents and to every path component.

### Only identifier starts are replaced

``IdentifierRenamer`` replaces a match only when the character before it is not a
letter, digit or underscore. Characters after the match are not checked, so suffixed
names follow the rename:

| Template text                   | After renaming to `MyShop` |
| ------------------------------- | -------------------------- |
| `EcommerceApp`                  | `MyShop`                   |
| `EcommerceAppTests`             | `MyShopTests`              |
| `@testable import EcommerceApp` | `@testable import MyShop`  |
| `com.example.EcommerceApp`      | `com.example.MyShop`       |
| `MyEcommerceApp`                | unchanged                  |

Types that do not start with the template name, such as `CommerceStore`, keep their
names.

### What is copied

All regular files under the template directory are copied, except build products and
generated projects: `.build`, `.swiftpm`, `DerivedData`, `xcuserdata`, `.DS_Store`,
`*.xcodeproj` and `*.xcworkspace`. Files that are not valid UTF-8 are copied byte for
byte without renaming.

### Failure handling

``Scaffolder/scaffold(_:as:in:)`` throws ``ScaffoldError/destinationExists(_:)`` before
writing anything if the destination already exists. If an error occurs after the
destination directory was created, the partially written directory is removed.
