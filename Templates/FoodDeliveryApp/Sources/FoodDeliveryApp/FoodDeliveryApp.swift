import SwiftUI
import FoodDeliveryAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct FoodDeliveryAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            FoodDeliveryDashboardView(
                snapshot: .sample,
                actions: FoodDeliveryQuickAction.defaultActions
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct FoodDeliveryDashboardView: View {
    public let snapshot: FoodDeliveryDashboardSnapshot
    public let actions: [FoodDeliveryQuickAction]

    public init(
        snapshot: FoodDeliveryDashboardSnapshot,
        actions: [FoodDeliveryQuickAction]
    ) {
        self.snapshot = snapshot
        self.actions = actions
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Delivery Overview") {
                    LabeledContent("Restaurants", value: "\(snapshot.restaurants)")
                    LabeledContent("Average ETA", value: snapshot.averageETA)
                    LabeledContent("Live Order", value: snapshot.liveOrderStatus)
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("FoodDeliveryApp")
        }
    }
}

public struct FoodDeliveryQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }

    public static let defaultActions: [FoodDeliveryQuickAction] = [
        FoodDeliveryQuickAction(title: "Browse Restaurants", systemImage: "fork.knife.circle.fill"),
        FoodDeliveryQuickAction(title: "Open Cart", systemImage: "cart.fill"),
        FoodDeliveryQuickAction(title: "Track Order", systemImage: "location.fill")
    ]
}
