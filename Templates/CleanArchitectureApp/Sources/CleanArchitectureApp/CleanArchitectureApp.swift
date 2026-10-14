import CleanArchitectureAppData
import CleanArchitectureAppDomain
import CleanArchitectureAppPresentation
import SwiftUI

/// The app scene. It builds the object graph once and hands the models to the screens.
@available(iOS 18.0, macOS 15.0, *)
public struct CleanArchitectureAppShell: App {
    @State private var container = CleanArchitectureAppContainer.sample()

    public init() {}

    public var body: some Scene {
        WindowGroup {
            CleanArchitectureAppRootView(container: container)
        }
    }
}

/// The three tabs. Each screen gets the models it needs and nothing from the Data layer.
@available(iOS 18.0, macOS 15.0, *)
public struct CleanArchitectureAppRootView: View {
    private let container: CleanArchitectureAppContainer

    public init(container: CleanArchitectureAppContainer) {
        self.container = container
    }

    public var body: some View {
        TabView {
            DirectoryView(model: container.directory)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Directory")
                }
            SummaryView(model: container.directory)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }
            SettingsView(directory: container.directory, settings: container.settings)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}
