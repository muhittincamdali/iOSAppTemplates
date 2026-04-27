import SwiftUI
import MarketplaceAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct MarketplaceAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MarketplaceWorkspaceRootView(
                snapshot: .sample,
                categories: MarketplaceCategoryCard.sampleCards,
                actions: MarketplaceQuickAction.defaultActions,
                health: .sample,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceWorkspaceRootView: View {
    let snapshot: MarketplaceDashboardSnapshot
    let categories: [MarketplaceCategoryCard]
    let actions: [MarketplaceQuickAction]
    let health: MarketplaceOperationalHealth
    let state: MarketplaceWorkspaceState

    var body: some View {
        TabView {
            MarketplaceDashboardView(
                snapshot: snapshot,
                categories: categories,
                actions: actions,
                health: health,
                state: state
            )
            .tabItem {
                Image(systemName: "bag.fill")
                Text("Home")
            }

            MarketplaceBrowseView(state: state)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Browse")
                }

            MarketplaceSellerDeskView(state: state)
                .tabItem {
                    Image(systemName: "storefront.fill")
                    Text("Seller")
                }

            MarketplaceOrdersView(state: state)
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Orders")
                }

            MarketplaceTrustView(health: health, state: state)
                .tabItem {
                    Image(systemName: "checkmark.shield.fill")
                    Text("Trust")
                }
        }
        .tint(.orange)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceDashboardView: View {
    let snapshot: MarketplaceDashboardSnapshot
    let categories: [MarketplaceCategoryCard]
    let actions: [MarketplaceQuickAction]
    let health: MarketplaceOperationalHealth
    let state: MarketplaceWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MarketplaceHeroCard(snapshot: snapshot, health: health, state: state)
                    MarketplaceQuickActionGrid(actions: actions)
                    MarketplaceFeaturedShelfView(listings: state.featuredListings)
                    MarketplaceCategoryLaneView(categories: categories)
                    MarketplaceOperationsCard(health: health, notes: state.operationsNotes)
                }
                .padding(16)
            }
            .navigationTitle("Marketplace")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceHeroCard: View {
    let snapshot: MarketplaceDashboardSnapshot
    let health: MarketplaceOperationalHealth
    let state: MarketplaceWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Marketplace Pulse")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.payoutHealth)
                .font(.title2.weight(.bold))
            Text("Buyer protection is active while the seller queue stays within the service window.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                MarketplaceMetricChip(title: "Listings", value: "\(snapshot.activeListings)")
                MarketplaceMetricChip(title: "Verified Sellers", value: "\(snapshot.verifiedSellers)")
                MarketplaceMetricChip(title: "Open Disputes", value: "\(snapshot.openDisputes)")
            }

            HStack {
                Label(state.merchandisingGoal, systemImage: "sparkles")
                Spacer()
                Text(state.fulfillmentSLA)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.16), .red.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceMetricChip: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceQuickActionGrid: View {
    let actions: [MarketplaceQuickAction]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.title3.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(actions) { action in
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: action.systemImage)
                            .font(.title3)
                            .foregroundStyle(.orange)
                        Text(action.title)
                            .font(.subheadline.weight(.semibold))
                        Text(action.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceFeaturedShelfView: View {
    let listings: [MarketplaceListing]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Shelf")
                .font(.title3.weight(.bold))

            ForEach(listings) { listing in
                NavigationLink {
                    MarketplaceListingDetailView(listing: listing)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(listing.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("\(listing.category) • \(listing.seller)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(listing.price)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.orange)
                        }
                        HStack {
                            Label(listing.rating, systemImage: "star.fill")
                            Label(listing.shippingLabel, systemImage: "truck.box.fill")
                            Label(listing.stockLabel, systemImage: "shippingbox")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceCategoryLaneView: View {
    let categories: [MarketplaceCategoryCard]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Merchandising Lanes")
                .font(.title3.weight(.bold))

            ForEach(categories) { category in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(category.title)
                            .font(.headline)
                        Text(category.ctaLabel)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(category.listingCount)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.orange)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceOperationsCard: View {
    let health: MarketplaceOperationalHealth
    let notes: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Operations")
                .font(.title3.weight(.bold))

            HStack(spacing: 12) {
                MarketplaceOperationTile(title: "Fraud Queue", value: "\(health.fraudReviewQueue)")
                MarketplaceOperationTile(title: "Seller SLA", value: "\(health.averageSellerResponseMinutes)m")
                MarketplaceOperationTile(title: "Protection", value: health.buyerProtectionReady ? "Ready" : "Paused")
            }

            ForEach(notes, id: \.self) { note in
                Label(note, systemImage: "arrow.right.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceOperationTile: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceBrowseView: View {
    let state: MarketplaceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Listings") {
                    ForEach(state.allListings) { listing in
                        NavigationLink {
                            MarketplaceListingDetailView(listing: listing)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(listing.title)
                                    Spacer()
                                    Text(listing.price)
                                        .font(.subheadline.weight(.bold))
                                }
                                Text("\(listing.category) • \(listing.seller)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section("Filters") {
                    ForEach(state.filters, id: \.self) { filter in
                        Label(filter, systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .navigationTitle("Browse")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceSellerDeskView: View {
    let state: MarketplaceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Seller Queue") {
                    ForEach(state.sellerQueue) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.title)
                                Spacer()
                                Text(item.status)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(item.statusColor)
                            }
                            Text(item.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Payouts") {
                    ForEach(state.payouts) { payout in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(payout.seller)
                                Text(payout.window)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(payout.amount)
                                .font(.headline.weight(.bold))
                        }
                    }
                }
            }
            .navigationTitle("Seller Desk")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceOrdersView: View {
    let state: MarketplaceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Buyer Orders") {
                    ForEach(state.orders) { order in
                        NavigationLink {
                            MarketplaceOrderDetailView(order: order)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(order.title)
                                    Spacer()
                                    Text(order.total)
                                        .font(.subheadline.weight(.bold))
                                }
                                Text("\(order.status) • \(order.shippingWindow)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceTrustView: View {
    let health: MarketplaceOperationalHealth
    let state: MarketplaceWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Trust Surface") {
                    LabeledContent("Fraud Queue", value: "\(health.fraudReviewQueue)")
                    LabeledContent("Buyer Protection", value: health.buyerProtectionReady ? "Active" : "Inactive")
                    LabeledContent("Average Seller Response", value: "\(health.averageSellerResponseMinutes) min")
                }

                Section("Disputes") {
                    ForEach(state.disputes) { dispute in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(dispute.title)
                                Spacer()
                                Text(dispute.level)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(dispute.levelColor)
                            }
                            Text(dispute.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Trust Rules") {
                    ForEach(state.trustRules, id: \.self) { rule in
                        Label(rule, systemImage: "checkmark.shield")
                    }
                }
            }
            .navigationTitle("Trust")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceListingDetailView: View {
    let listing: MarketplaceListing

    var body: some View {
        List {
            Section("Listing") {
                LabeledContent("Title", value: listing.title)
                LabeledContent("Seller", value: listing.seller)
                LabeledContent("Price", value: listing.price)
                LabeledContent("Shipping", value: listing.shippingLabel)
                LabeledContent("Stock", value: listing.stockLabel)
            }

            Section("Trust") {
                LabeledContent("Rating", value: listing.rating)
                Text(listing.description)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Listing")
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceOrderDetailView: View {
    let order: MarketplaceOrder

    var body: some View {
        List {
            Section("Order") {
                LabeledContent("Item", value: order.title)
                LabeledContent("Status", value: order.status)
                LabeledContent("Shipping Window", value: order.shippingWindow)
                LabeledContent("Seller", value: order.seller)
                LabeledContent("Total", value: order.total)
            }

            Section("Support") {
                ForEach(order.supportNotes, id: \.self) { note in
                    Label(note, systemImage: "message.fill")
                }
            }
        }
        .navigationTitle("Order")
    }
}

public struct MarketplaceQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let detail: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        detail: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.detail = detail
        self.systemImage = systemImage
    }

    public static let defaultActions: [MarketplaceQuickAction] = [
        MarketplaceQuickAction(title: "Review Seller Queue", detail: "Close KYC, moderation and payout blockers before the next release window.", systemImage: "person.3.fill"),
        MarketplaceQuickAction(title: "Open Buyer Protection", detail: "Check pending disputes and keep protection coverage within SLA.", systemImage: "shield.checkered"),
        MarketplaceQuickAction(title: "Inspect Featured Shelf", detail: "Review merchandising quality and refresh the conversion-driving hero items.", systemImage: "sparkles.rectangle.stack.fill"),
        MarketplaceQuickAction(title: "Resolve Shipping Risk", detail: "Prioritize orders that are close to missing their promise window.", systemImage: "truck.box.badge.clock")
    ]
}

struct MarketplaceWorkspaceState: Hashable, Sendable {
    let merchandisingGoal: String
    let fulfillmentSLA: String
    let featuredListings: [MarketplaceListing]
    let allListings: [MarketplaceListing]
    let sellerQueue: [MarketplaceSellerQueueItem]
    let payouts: [MarketplacePayout]
    let orders: [MarketplaceOrder]
    let disputes: [MarketplaceDispute]
    let operationsNotes: [String]
    let trustRules: [String]
    let filters: [String]

    static let sample = MarketplaceWorkspaceState(
        merchandisingGoal: "Lift conversion on featured tech without raising dispute volume.",
        fulfillmentSLA: "97% shipped within SLA",
        featuredListings: [
            MarketplaceListing(title: "Mirrorless Creator Camera", category: "Featured Tech", seller: "North Studio", price: "$1,240", rating: "4.9", shippingLabel: "Ships tomorrow", stockLabel: "12 left", description: "Creator-focused bundle with lens, battery kit and verified warranty."),
            MarketplaceListing(title: "Home Podcast Mixer", category: "Home Studio", seller: "Wave Supply", price: "$389", rating: "4.8", shippingLabel: "2-day delivery", stockLabel: "8 left", description: "Compact mixer for remote interviews and live monitoring."),
            MarketplaceListing(title: "Refurbished Ultrabook", category: "Pre-owned Deals", seller: "Renew Point", price: "$799", rating: "4.7", shippingLabel: "Free delivery", stockLabel: "5 left", description: "Certified refurbished laptop with health report and seller-backed return window.")
        ],
        allListings: [
            MarketplaceListing(title: "Mirrorless Creator Camera", category: "Featured Tech", seller: "North Studio", price: "$1,240", rating: "4.9", shippingLabel: "Ships tomorrow", stockLabel: "12 left", description: "Creator-focused bundle with lens, battery kit and verified warranty."),
            MarketplaceListing(title: "Home Podcast Mixer", category: "Home Studio", seller: "Wave Supply", price: "$389", rating: "4.8", shippingLabel: "2-day delivery", stockLabel: "8 left", description: "Compact mixer for remote interviews and live monitoring."),
            MarketplaceListing(title: "Refurbished Ultrabook", category: "Pre-owned Deals", seller: "Renew Point", price: "$799", rating: "4.7", shippingLabel: "Free delivery", stockLabel: "5 left", description: "Certified refurbished laptop with health report and seller-backed return window."),
            MarketplaceListing(title: "Portable Smart Projector", category: "Featured Tech", seller: "Frame House", price: "$549", rating: "4.6", shippingLabel: "Pickup today", stockLabel: "14 left", description: "Compact projector with verified brightness and low-noise travel case.")
        ],
        sellerQueue: [
            MarketplaceSellerQueueItem(title: "KYC refresh for Renew Point", detail: "Payout release is blocked until beneficial owner verification is completed.", status: "Needs review", statusColor: .orange),
            MarketplaceSellerQueueItem(title: "Listing moderation for audio gear bundle", detail: "Duplicate-image complaint requires a seller response before relisting.", status: "Blocked", statusColor: .red),
            MarketplaceSellerQueueItem(title: "Holiday shelf prep for North Studio", detail: "Featured placement is ready once the stock sync finishes.", status: "Ready", statusColor: .green)
        ],
        payouts: [
            MarketplacePayout(seller: "North Studio", amount: "$4,280", window: "Daily payout • 18:00"),
            MarketplacePayout(seller: "Wave Supply", amount: "$2,640", window: "Daily payout • 18:00"),
            MarketplacePayout(seller: "Renew Point", amount: "$0", window: "Held for compliance review")
        ],
        orders: [
            MarketplaceOrder(title: "Mirrorless Creator Camera", seller: "North Studio", status: "Packed", shippingWindow: "Arrives Apr 29", total: "$1,240", supportNotes: ["Buyer asked for signature delivery.", "Courier handoff scheduled at 17:00."]),
            MarketplaceOrder(title: "Refurbished Ultrabook", seller: "Renew Point", status: "Awaiting verification", shippingWindow: "Needs manual review", total: "$799", supportNotes: ["Protection hold until serial report is uploaded."])
        ],
        disputes: [
            MarketplaceDispute(title: "Missing accessory claim", detail: "Buyer reported the spare battery was missing from the camera bundle.", level: "Medium", levelColor: .orange),
            MarketplaceDispute(title: "Seller authenticity challenge", detail: "One refurbished device needs updated proof of component replacement.", level: "High", levelColor: .red)
        ],
        operationsNotes: [
            "Refresh the hero shelf after the weekend conversion report lands.",
            "Clear held payouts before the nightly reconciliation batch.",
            "Review dispute escalation backlog before adding more paid traffic."
        ],
        trustRules: [
            "Held payouts stay blocked until KYC and authenticity checks pass.",
            "Featured listings need verified inventory and return coverage.",
            "Buyer protection escalates automatically when delivery promises slip."
        ],
        filters: [
            "Verified sellers",
            "Fast shipping",
            "High trust rating",
            "Low return risk"
        ]
    )
}

struct MarketplaceListing: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let category: String
    let seller: String
    let price: String
    let rating: String
    let shippingLabel: String
    let stockLabel: String
    let description: String
}

struct MarketplaceSellerQueueItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let status: String
    let statusColor: Color
}

struct MarketplacePayout: Identifiable, Hashable, Sendable {
    let id = UUID()
    let seller: String
    let amount: String
    let window: String
}

struct MarketplaceOrder: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let seller: String
    let status: String
    let shippingWindow: String
    let total: String
    let supportNotes: [String]
}

struct MarketplaceDispute: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let level: String
    let levelColor: Color
}
