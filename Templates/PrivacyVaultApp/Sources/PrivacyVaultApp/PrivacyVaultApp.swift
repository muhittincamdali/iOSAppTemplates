import SwiftUI
import PrivacyVaultAppCore
import PrivacyVaultAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct PrivacyVaultAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            PrivacyVaultDashboardView(
                snapshot: .sample,
                collections: PrivacyVaultCollectionCard.sampleCards,
                actions: PrivacyVaultQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct PrivacyVaultDashboardView: View {
    public let snapshot: PrivacyVaultDashboardSnapshot
    public let collections: [PrivacyVaultCollectionCard]
    public let actions: [PrivacyVaultQuickAction]
    public let health: PrivacyVaultOperationalHealth

    public init(
        snapshot: PrivacyVaultDashboardSnapshot,
        collections: [PrivacyVaultCollectionCard],
        actions: [PrivacyVaultQuickAction],
        health: PrivacyVaultOperationalHealth
    ) {
        self.snapshot = snapshot
        self.collections = collections
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Privacy Overview") {
                    PrivacyVaultSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Vault Lanes") {
                    ForEach(collections) { collection in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(collection.title)
                            Text("\(collection.itemCount) items")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(collection.ctaLabel)
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
            .navigationTitle("PrivacyVaultApp")
        }
    }
}

public struct PrivacyVaultQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [PrivacyVaultQuickAction] = [
        PrivacyVaultQuickAction(title: "Review Access Alerts", systemImage: "shield.lefthalf.filled.badge.checkmark"),
        PrivacyVaultQuickAction(title: "Open Recovery Check", systemImage: "key.horizontal.fill"),
        PrivacyVaultQuickAction(title: "Inspect Shared Vaults", systemImage: "person.crop.rectangle.stack.fill")
    ]
}
