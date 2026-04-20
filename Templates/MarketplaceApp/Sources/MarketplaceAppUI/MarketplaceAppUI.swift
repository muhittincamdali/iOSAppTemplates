import SwiftUI
import MarketplaceAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct MarketplaceSummaryCard: View {
    public let snapshot: MarketplaceDashboardSnapshot
    public let health: MarketplaceOperationalHealth

    public init(
        snapshot: MarketplaceDashboardSnapshot,
        health: MarketplaceOperationalHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.activeListings) active listings", systemImage: "shippingbox.fill")
            Label("\(snapshot.verifiedSellers) verified sellers", systemImage: "person.badge.shield.checkmark.fill")
            Label("\(snapshot.openDisputes) disputes open", systemImage: "exclamationmark.bubble.fill")
            Label(snapshot.payoutHealth, systemImage: "creditcard.fill")
            Label(
                "\(health.averageSellerResponseMinutes) min median seller response",
                systemImage: health.buyerProtectionReady ? "checkmark.seal.fill" : "xmark.seal.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
