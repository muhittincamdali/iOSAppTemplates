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

### Names that are already taken

Because the rename is a text substitution, a project name must not turn into a name
the template already uses. Scaffolding the E-commerce template as `CommerceStore` would
give the module the name of the existing `CommerceStore` class, and `EcommerceApp.swift`
would overwrite `CommerceStore.swift`. ``Scaffolder`` compares the renamed names with the
template's file and folder names and with the names declared in its Swift files (words
in strings and comments do not count), and compares file paths ignoring case. On a
clash it throws ``ScaffoldError/nameConflict(_:_:)`` and lists the names.

### What is copied

All regular files under the template directory are copied, except build products and
generated projects: `.build`, `.swiftpm`, `DerivedData`, `xcuserdata`, `.DS_Store`,
`*.xcodeproj` and `*.xcworkspace`. Files that are not valid UTF-8 are copied byte for
byte without renaming.

### Failure handling

``Scaffolder/scaffold(_:as:in:)`` throws ``ScaffoldError/destinationExists(_:)`` or
``ScaffoldError/nameConflict(_:_:)`` before writing anything. If an error occurs after the
destination directory was created, the partially written directory is removed.
