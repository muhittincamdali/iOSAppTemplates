# Examples

## QuickStart

[`QuickStart/`](QuickStart) is the app you get by following the
[quick start](../README.md#quick-start): an iOS app project that adds
[`Templates/EcommerceApp`](../Templates/EcommerceApp) as a local Swift package and starts its
scene. The whole app is one file,
[`QuickStartApp.swift`](QuickStart/QuickStart/QuickStartApp.swift).

To run it:

1. Clone the repository and open `Examples/QuickStart/QuickStart.xcodeproj` in Xcode.
2. Choose an iPhone simulator in the toolbar.
3. Press **Run** (⌘R). The Shop tab of the E-commerce template appears.

To try another template, select the project in the navigator, remove the `EcommerceApp`
package under **Package Dependencies**, add another folder from `Templates/` with
**File › Add Package Dependencies… › Add Local…**, and change the two names in
`QuickStartApp.swift`, for example to `import FinanceApp` and `FinanceAppShell.main()`.

CI builds this project for the iOS Simulator on every push and pull request
([`templates.yml`](../.github/workflows/templates.yml)).
