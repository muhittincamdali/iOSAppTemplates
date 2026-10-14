# Adding a Template to an App

Run a template inside an app project you created in Xcode, without XcodeGen.

## Overview

Every template is a Swift package with one library. Its entry point is `<Name>Shell`, a
SwiftUI `App` whose scene contains the template's tab bar, screens and sample data. In most
templates it is the only public type; `CleanArchitectureApp` also makes its layers public so
they can be tested and reused. An app target that starts this scene runs the whole template; the app target
itself needs a single file.

This is the setup of the quick start in the repository README and of the `QuickStart`
project in the repository's `Examples` folder.

### Pick the package

Use a template folder from a clone of the repository, for example
`iOSAppTemplates/Templates/EcommerceApp`, or a copy with your own name created with
`create-ios-app` (see <doc:GettingStarted>). A copy is the better choice when you plan to
change the code, because edits to a template folder change the clone.

### Add the package in Xcode

1. Open your app project, or create one with **File › New › Project… › iOS › App**. Its
   deployment target must be iOS 18 or later.
2. Choose **File › Add Package Dependencies…** and click **Add Local…** at the bottom of the
   dialog.
3. Select the package folder (the one that contains `Package.swift`) and click
   **Add Package**. When Xcode asks which products to add, add the library, for example
   `EcommerceApp`, to your app target.

### Start the template's scene

Replace the contents of the file that contains `@main` (in a new project, the file named
after the product, such as `MyAppApp.swift`) with:

```swift
import EcommerceApp

@main
enum QuickStartApp {
    static func main() {
        EcommerceAppShell.main()
    }
}
```

`EcommerceAppShell` declares the window, so the app target needs no `WindowGroup` of its own.
`ContentView.swift` from the Xcode template is no longer used and can be deleted. Choose an
iPhone simulator and run the app: the Shop tab of the E-commerce template appears.

For another template, change both names: `import FinanceApp` and `FinanceAppShell.main()`,
and so on. A package created by `create-ios-app` as `MyShop` exports `MyShopShell`.

### Change the template

Screens and state live in the package, not in the app target. Each template keeps its
sample data and actions in a store class (`SocialMediaApp` splits them across three
managers), so you can replace the sample data in the store's initializer, or move the store
behind your own service, while the screens stay as they are. The store's tests in
`Tests/<Name>Tests` show which behaviour the screens rely on.
