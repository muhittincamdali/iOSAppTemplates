import SwiftUI
import MarketplaceAppCore
import MarketplaceAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct MarketplaceAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MarketplaceDashboardView(
                snapshot: .sample,
                categories: MarketplaceCategoryCard.sampleCards,
                actions: MarketplaceQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MarketplaceDashboardView: View {
    public let snapshot: MarketplaceDashboardSnapshot
    public let categories: [MarketplaceCategoryCard]
    public let actions: [MarketplaceQuickAction]
    public let health: MarketplaceOperationalHealth

    public init(
        snapshot: MarketplaceDashboardSnapshot,
        categories: [MarketplaceCategoryCard],
        actions: [MarketplaceQuickAction],
        health: MarketplaceOperationalHealth
    ) {
        self.snapshot = snapshot
        self.categories = categories
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Marketplace Overview") {
                    MarketplaceSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Merchandising Lanes") {
                    ForEach(categories) { category in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(category.title)
                            Text("\(category.listingCount) listings")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(category.ctaLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("MarketplaceApp")
        }
    }
}

public struct MarketplaceQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [MarketplaceQuickAction] = [
        MarketplaceQuickAction(title: "Review Seller Queue", systemImage: "person.3.fill"),
        MarketplaceQuickAction(title: "Open Buyer Protection", systemImage: "shield.checkered"),
        MarketplaceQuickAction(title: "Inspect Featured Shelf", systemImage: "sparkles.rectangle.stack.fill")
    ]
}
