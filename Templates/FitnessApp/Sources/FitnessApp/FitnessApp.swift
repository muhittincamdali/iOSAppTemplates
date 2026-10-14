import Foundation
import SwiftUI

@available(iOS 18.0, macOS 15.0, *)
public struct FitnessAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            FitnessRootView()
        }
    }
}

struct FitnessRootView: View {
    @StateObject private var store = FitnessStudioStore()

    var body: some View {
        TabView {
            FitnessDashboardView(store: store)
                .tabItem {
                    Image(systemName: "figure.strengthtraining.traditional")
                    Text("Plan")
                }

            FitnessSessionWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Session")
                }

            FitnessProgressWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }

            FitnessRecoveryWorkspaceView(store: store)
                .tabItem {
                    Image(systemName: "heart.text.square.fill")
                    Text("Recovery")
                }

            FitnessProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.green)
    }
}
