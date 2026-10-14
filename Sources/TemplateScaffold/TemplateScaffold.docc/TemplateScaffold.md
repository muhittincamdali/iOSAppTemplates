# ``TemplateScaffold``

Create a new SwiftUI app package from one of the twenty templates in this repository.

## Overview

The repository ships twenty iOS app templates under `Templates/`. Each one is a Swift
package with a SwiftUI app module, a Swift Testing target and an XcodeGen host project.
This library copies one of those packages to a new location and renames it, so that
`EcommerceApp`, `EcommerceAppTests`, `EcommerceAppShell` and `com.example.EcommerceApp`
become `MyShop`, `MyShopTests`, `MyShopShell` and `com.example.MyShop`.

The `create-ios-app` command-line tool is a thin wrapper around this library:

```bash
swift run create-ios-app list
swift run create-ios-app new MyShop --template ecommerce --output ~/Developer
```

You can also call the library directly:

```swift
import Foundation
import TemplateScaffold

func makeShop(templates: URL, output: URL) throws -> ScaffoldResult {
    guard let template = TemplateCatalog.template(named: "ecommerce") else {
        throw CocoaError(.fileNoSuchFile)
    }
    let name = try ProjectName("MyShop")
    return try Scaffolder(templatesDirectory: templates).scaffold(template, as: name, in: output)
}
```

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:AddingATemplateToAnApp>
- <doc:HowRenamingWorks>

### Choosing a template

- ``TemplateCatalog``
- ``TemplateDescriptor``
- ``TemplateLocator``

### Creating a project

- ``ProjectName``
- ``ProjectNameError``
- ``Scaffolder``
- ``ScaffoldResult``
- ``ScaffoldError``
- ``IdentifierRenamer``
