import Foundation
import SwiftUI
import MarketplaceAppCore

private enum MarketplaceInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "MarketplaceApp",
            "status": "completed",
            "summary": summary,
            "steps": steps,
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        guard JSONSerialization.isValidJSONObject(payload),
              let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted, .sortedKeys]) else {
            return
        }

        try? data.write(to: documentsURL.appendingPathComponent("interaction-proof.json"), options: [.atomic])
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct MarketplaceAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            MarketplaceRuntimeRootView()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceRuntimeRootView: View {
    @StateObject private var store = MarketplaceOperationsStore()

    var body: some View {
        TabView {
            MarketplaceDashboardView(store: store)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Home")
                }

            MarketplaceBrowseView(store: store)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Browse")
                }

            MarketplaceSellerDeskView(store: store)
                .tabItem {
                    Image(systemName: "storefront.fill")
                    Text("Seller")
                }

            MarketplaceOrdersView(store: store)
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Orders")
                }

            MarketplaceTrustView(store: store)
                .tabItem {
                    Image(systemName: "checkmark.shield.fill")
                    Text("Trust")
                }
        }
        .tint(.orange)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
@MainActor
final class MarketplaceOperationsStore: ObservableObject {
    @Published var selectedCategory = "Featured Tech"
    @Published var cart: [MarketplaceCartItem]
    @Published var listings: [MarketplaceListingRecord]
    @Published var sellerQueue: [MarketplaceSellerQueueRecord]
    @Published var payouts: [MarketplacePayoutRecord]
    @Published var orders: [MarketplaceOrderRecord]
    @Published var disputes: [MarketplaceDisputeRecord]
    @Published var operatorNotes: [String]
    @Published var trustRules: [String]
    @Published var fulfillmentHeadline: String
    private var interactionProofScheduled = false

    init() {
        self.fulfillmentHeadline = "Keep buyer conversion high without letting disputes or payout holds spike."
        self.listings = [
            MarketplaceListingRecord(title: "Mirrorless Creator Camera", category: "Featured Tech", seller: "North Studio", price: 1240, rating: 4.9, shippingLabel: "Ships tomorrow", stockCount: 12, description: "Creator-focused bundle with lens, battery kit and verified warranty.", isWishlisted: false, isReserved: false),
            MarketplaceListingRecord(title: "Home Podcast Mixer", category: "Home Studio", seller: "Wave Supply", price: 389, rating: 4.8, shippingLabel: "2-day delivery", stockCount: 8, description: "Compact mixer for remote interviews and live monitoring.", isWishlisted: true, isReserved: false),
            MarketplaceListingRecord(title: "Refurbished Ultrabook", category: "Pre-owned Deals", seller: "Renew Point", price: 799, rating: 4.7, shippingLabel: "Free delivery", stockCount: 5, description: "Certified refurbished laptop with health report and seller-backed return window.", isWishlisted: false, isReserved: false),
            MarketplaceListingRecord(title: "Portable Smart Projector", category: "Featured Tech", seller: "Frame House", price: 549, rating: 4.6, shippingLabel: "Pickup today", stockCount: 14, description: "Compact projector with verified brightness and a travel case.", isWishlisted: false, isReserved: false)
        ]
        self.cart = [
            MarketplaceCartItem(listingTitle: "Home Podcast Mixer", seller: "Wave Supply", price: 389, quantity: 1)
        ]
        self.sellerQueue = [
            MarketplaceSellerQueueRecord(title: "KYC refresh for Renew Point", detail: "Payout release is blocked until beneficial owner verification is complete.", status: .needsReview),
            MarketplaceSellerQueueRecord(title: "Listing moderation for audio gear bundle", detail: "Duplicate-image complaint requires a seller response before relisting.", status: .blocked),
            MarketplaceSellerQueueRecord(title: "Holiday shelf prep for North Studio", detail: "Featured placement is ready once stock sync finishes.", status: .ready)
        ]
        self.payouts = [
            MarketplacePayoutRecord(seller: "North Studio", amount: 4280, window: "Daily payout • 18:00", isHeld: false),
            MarketplacePayoutRecord(seller: "Wave Supply", amount: 2640, window: "Daily payout • 18:00", isHeld: false),
            MarketplacePayoutRecord(seller: "Renew Point", amount: 0, window: "Held for compliance review", isHeld: true)
        ]
        self.orders = [
            MarketplaceOrderRecord(title: "Mirrorless Creator Camera", seller: "North Studio", status: .packed, shippingWindow: "Arrives Apr 29", total: 1240, supportNotes: ["Buyer asked for signature delivery.", "Courier handoff scheduled at 17:00."], supportStatus: "Packing"),
            MarketplaceOrderRecord(title: "Refurbished Ultrabook", seller: "Renew Point", status: .manualReview, shippingWindow: "Needs manual review", total: 799, supportNotes: ["Protection hold until serial report is uploaded."], supportStatus: "Compliance hold")
        ]
        self.disputes = [
            MarketplaceDisputeRecord(title: "Missing accessory claim", detail: "Buyer reported the spare battery was missing from the camera bundle.", level: .medium, status: .open),
            MarketplaceDisputeRecord(title: "Seller authenticity challenge", detail: "A refurbished device needs updated proof of component replacement.", level: .high, status: .open)
        ]
        self.operatorNotes = [
            "Refresh the hero shelf after the weekend conversion report lands.",
            "Clear held payouts before the nightly reconciliation batch.",
            "Review dispute backlog before adding more paid traffic."
        ]
        self.trustRules = [
            "Held payouts stay blocked until KYC and authenticity checks pass.",
            "Featured listings need verified inventory and return coverage.",
            "Buyer protection escalates automatically when delivery promises slip."
        ]
    }

    var featuredListings: [MarketplaceListingRecord] {
        listings.filter { $0.category == selectedCategory || ($0.category == "Featured Tech" && selectedCategory == "Featured Tech") }
    }

    var subtotal: Double {
        cart.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }

    var trustExposureCount: Int {
        disputes.filter { $0.status == .open || $0.status == .escalated }.count
    }

    var heldPayoutCount: Int {
        payouts.filter(\.isHeld).count
    }

    func selectCategory(_ category: String) {
        selectedCategory = category
    }

    func toggleWishlist(_ listing: MarketplaceListingRecord) {
        guard let index = listings.firstIndex(where: { $0.id == listing.id }) else { return }
        listings[index].isWishlisted.toggle()
    }

    func reserveListing(_ listing: MarketplaceListingRecord) {
        guard let index = listings.firstIndex(where: { $0.id == listing.id }), listings[index].stockCount > 0 else { return }
        listings[index].stockCount -= 1
        listings[index].isReserved = true
        if let cartIndex = cart.firstIndex(where: { $0.listingTitle == listing.title }) {
            cart[cartIndex].quantity += 1
        } else {
            cart.append(MarketplaceCartItem(listingTitle: listing.title, seller: listing.seller, price: listing.price, quantity: 1))
        }
    }

    func incrementCart(_ item: MarketplaceCartItem) {
        guard let index = cart.firstIndex(where: { $0.id == item.id }) else { return }
        cart[index].quantity += 1
    }

    func decrementCart(_ item: MarketplaceCartItem) {
        guard let index = cart.firstIndex(where: { $0.id == item.id }) else { return }
        if cart[index].quantity == 1 {
            cart.remove(at: index)
        } else {
            cart[index].quantity -= 1
        }
    }

    func placeReservedOrder() {
        guard let item = cart.first else { return }
        orders.insert(
            MarketplaceOrderRecord(
                title: item.listingTitle,
                seller: item.seller,
                status: .processing,
                shippingWindow: "Processing for next courier window",
                total: item.price * Double(item.quantity),
                supportNotes: ["Buyer checkout completed.", "Seller confirmation required in 30 minutes."],
                supportStatus: "Awaiting seller confirmation"
            ),
            at: 0
        )
        cart.removeAll()
        fulfillmentHeadline = "New order placed and routed into seller confirmation."
    }

    func advanceOrder(_ order: MarketplaceOrderRecord) {
        guard let index = orders.firstIndex(where: { $0.id == order.id }) else { return }
        switch orders[index].status {
        case .processing:
            orders[index].status = .packed
            orders[index].shippingWindow = "Courier pickup locked"
            orders[index].supportStatus = "Seller confirmed"
            orders[index].supportNotes.append("Seller confirmation landed and the parcel moved into packing.")
        case .packed:
            orders[index].status = .shipped
            orders[index].shippingWindow = "In transit"
            orders[index].supportStatus = "In transit"
            orders[index].supportNotes.append("Courier accepted the parcel and started the transit scan.")
        case .shipped:
            orders[index].status = .delivered
            orders[index].shippingWindow = "Delivered"
            orders[index].supportStatus = "Delivered cleanly"
            orders[index].supportNotes.append("Buyer delivery promise closed without a breach.")
        case .manualReview, .delivered:
            break
        }
    }

    func releaseSellerQueue(_ item: MarketplaceSellerQueueRecord) {
        guard let index = sellerQueue.firstIndex(where: { $0.id == item.id }) else { return }
        sellerQueue[index].status = .ready
        operatorNotes.insert("Released queue item: \(sellerQueue[index].title).", at: 0)
    }

    func verifySellerQueue(_ item: MarketplaceSellerQueueRecord) {
        guard let index = sellerQueue.firstIndex(where: { $0.id == item.id }) else { return }
        sellerQueue[index].status = .needsReview
        operatorNotes.insert("Verification pass started for: \(sellerQueue[index].title).", at: 0)
        fulfillmentHeadline = "Seller verification route is active before payout or shelf release."
    }

    func holdPayout(_ payout: MarketplacePayoutRecord) {
        guard let index = payouts.firstIndex(where: { $0.id == payout.id }) else { return }
        payouts[index].isHeld = true
        payouts[index].window = "Held for trust review"
    }

    func releasePayout(_ payout: MarketplacePayoutRecord) {
        guard let index = payouts.firstIndex(where: { $0.id == payout.id }) else { return }
        payouts[index].isHeld = false
        payouts[index].window = "Released for nightly settlement"
    }

    func resolveDispute(_ dispute: MarketplaceDisputeRecord) {
        guard let index = disputes.firstIndex(where: { $0.id == dispute.id }) else { return }
        disputes[index].status = .resolved
        operatorNotes.insert("Resolved dispute: \(disputes[index].title).", at: 0)
        if let payoutIndex = payouts.firstIndex(where: \.isHeld) {
            payouts[payoutIndex].isHeld = false
            payouts[payoutIndex].window = "Released after trust resolution"
        }
    }

    func escalateDispute(_ dispute: MarketplaceDisputeRecord) {
        guard let index = disputes.firstIndex(where: { $0.id == dispute.id }) else { return }
        disputes[index].status = .escalated
        if let sellerIndex = sellerQueue.firstIndex(where: { $0.title.contains("Renew Point") || $0.title.contains("audio gear") }) {
            sellerQueue[sellerIndex].status = .blocked
        }
    }

    func clearManualReview(_ order: MarketplaceOrderRecord) {
        guard let index = orders.firstIndex(where: { $0.id == order.id }) else { return }
        orders[index].status = .processing
        orders[index].shippingWindow = "Review cleared • seller confirmation requested"
        orders[index].supportStatus = "Review cleared"
        orders[index].supportNotes.append("Manual review cleared and routed back into the seller confirmation lane.")
        fulfillmentHeadline = "Manual review cleared and the buyer order is moving again."
    }

    func requestBuyerProtection(_ order: MarketplaceOrderRecord) {
        guard let index = orders.firstIndex(where: { $0.id == order.id }) else { return }
        orders[index].status = .manualReview
        orders[index].shippingWindow = "Buyer protection investigation active"
        orders[index].supportStatus = "Protection hold"
        orders[index].supportNotes.append("Buyer protection route opened after delivery and funds are held.")
        payouts = payouts.map { payout in
            var updated = payout
            if updated.seller == orders[index].seller {
                updated.isHeld = true
                updated.window = "Held for buyer protection review"
            }
            return updated
        }
        disputes.insert(
            MarketplaceDisputeRecord(
                title: "Buyer protection for \(orders[index].title)",
                detail: "Post-delivery issue routed into buyer protection with payout hold in place.",
                level: .high,
                status: .open
            ),
            at: 0
        )
        fulfillmentHeadline = "Buyer protection case opened and seller funds are held pending resolution."
    }

    func runInteractionProofIfNeeded() {
        guard MarketplaceInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 800_000_000)

            selectCategory("Home Studio")

            if let listing = listings.first(where: { $0.category == "Home Studio" }) ?? listings.first {
                toggleWishlist(listing)
                reserveListing(listing)
            }

            if let cartItem = cart.first {
                incrementCart(cartItem)
            }

            placeReservedOrder()

            if let newestOrder = orders.first {
                advanceOrder(newestOrder)
                if let updated = orders.first {
                    advanceOrder(updated)
                }
                if let updated = orders.first {
                    requestBuyerProtection(updated)
                }
            }

            if let queueItem = sellerQueue.first {
                verifySellerQueue(queueItem)
                releaseSellerQueue(queueItem)
            }

            if let heldPayout = payouts.first(where: \.isHeld) {
                holdPayout(heldPayout)
                releasePayout(heldPayout)
            }

            if let dispute = disputes.first {
                escalateDispute(dispute)
                resolveDispute(dispute)
            }

            MarketplaceInteractionProofMode.write(
                summary: fulfillmentHeadline,
                steps: [
                    "category-selected",
                    "listing-wishlisted-and-reserved",
                    "cart-updated",
                    "reserved-order-placed",
                    "order-advanced-and-protection-opened",
                    "seller-queue-verified-and-released",
                    "payout-released",
                    "dispute-escalated-and-resolved"
                ]
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceDashboardView: View {
    @ObservedObject var store: MarketplaceOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Marketplace Pulse")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(store.fulfillmentHeadline)
                            .font(.title2.weight(.bold))
                        HStack(spacing: 12) {
                            MarketplaceMetricChip(title: "Held Payouts", value: "\(store.heldPayoutCount)")
                            MarketplaceMetricChip(title: "Trust Cases", value: "\(store.trustExposureCount)")
                            MarketplaceMetricChip(title: "Cart", value: "\(store.cart.count)")
                        }
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

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Merchandising Lanes")
                            .font(.title3.weight(.bold))
                        ForEach(["Featured Tech", "Home Studio", "Pre-owned Deals"], id: \.self) { category in
                            Button {
                                store.selectCategory(category)
                            } label: {
                                HStack {
                                    Text(category)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    if store.selectedCategory == category {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.orange)
                                    }
                                }
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Featured Shelf")
                            .font(.title3.weight(.bold))
                        ForEach(store.featuredListings) { listing in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(listing.title)
                                            .font(.headline)
                                        Text("\(listing.seller) • \(listing.shippingLabel)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(listing.price.currencyString)
                                        .font(.headline.weight(.bold))
                                        .foregroundStyle(.orange)
                                }
                                Text(listing.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    Button(listing.isWishlisted ? "Unsave" : "Save") {
                                        store.toggleWishlist(listing)
                                    }
                                    .buttonStyle(.bordered)
                                    Button("Reserve") {
                                        store.reserveListing(listing)
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
                .padding(16)
            }
            .navigationTitle("Marketplace")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceBrowseView: View {
    @ObservedObject var store: MarketplaceOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Listings") {
                    ForEach(store.listings) { listing in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(listing.title)
                                Spacer()
                                Text(listing.price.currencyString)
                                    .font(.subheadline.weight(.bold))
                            }
                            Text("\(listing.category) • \(listing.seller)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("Stock: \(listing.stockCount) • Rating: \(String(format: "%.1f", listing.rating))")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button(listing.isWishlisted ? "Unsave" : "Save") {
                                    store.toggleWishlist(listing)
                                }
                                .buttonStyle(.bordered)
                                Button("Reserve") {
                                    store.reserveListing(listing)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Browse")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceSellerDeskView: View {
    @ObservedObject var store: MarketplaceOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Seller Queue") {
                    ForEach(store.sellerQueue) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.title)
                                Spacer()
                                Text(item.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(item.status.color)
                            }
                            Text(item.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            if item.status == .blocked {
                                HStack {
                                    Button("Start Verification") {
                                        store.verifySellerQueue(item)
                                    }
                                    .buttonStyle(.bordered)
                                    Button("Release Queue Item") {
                                        store.releaseSellerQueue(item)
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            } else if item.status == .needsReview {
                                Button("Release Queue Item") {
                                    store.releaseSellerQueue(item)
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Payouts") {
                    ForEach(store.payouts) { payout in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(payout.seller)
                                    Text(payout.window)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(payout.amount.currencyString)
                                    .font(.headline.weight(.bold))
                            }
                            Button(payout.isHeld ? "Release Payout" : "Hold Payout") {
                                payout.isHeld ? store.releasePayout(payout) : store.holdPayout(payout)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Seller Desk")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceOrdersView: View {
    @ObservedObject var store: MarketplaceOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Cart") {
                    ForEach(store.cart) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.listingTitle)
                                Spacer()
                                Text("\(item.quantity)x")
                                    .font(.caption.weight(.semibold))
                            }
                            Text(item.price.currencyString)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button("-") {
                                    store.decrementCart(item)
                                }
                                .buttonStyle(.bordered)
                                Button("+") {
                                    store.incrementCart(item)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    if !store.cart.isEmpty {
                        Button("Place Order • \(store.subtotal.currencyString)") {
                            store.placeReservedOrder()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }

                Section("Buyer Orders") {
                    ForEach(store.orders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(order.title)
                                Spacer()
                                Text(order.total.currencyString)
                                    .font(.subheadline.weight(.bold))
                            }
                            Text("\(order.status.label) • \(order.shippingWindow)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(order.supportStatus)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                            if order.status == .manualReview {
                                Button("Clear Manual Review") {
                                    store.clearManualReview(order)
                                }
                                .buttonStyle(.borderedProminent)
                            } else if order.status == .delivered {
                                Button("Open Buyer Protection") {
                                    store.requestBuyerProtection(order)
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Button("Advance Order") {
                                    store.advanceOrder(order)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct MarketplaceTrustView: View {
    @ObservedObject var store: MarketplaceOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Trust Surface") {
                    LabeledContent("Open trust exposure", value: "\(store.trustExposureCount)")
                    LabeledContent("Held payouts", value: "\(store.heldPayoutCount)")
                    LabeledContent("Selected lane", value: store.selectedCategory)
                }

                Section("Disputes") {
                    ForEach(store.disputes) { dispute in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(dispute.title)
                                Spacer()
                                Text(dispute.status.label)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(dispute.status.color)
                            }
                            Text(dispute.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(dispute.level.label)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(dispute.level.color)
                            if dispute.status == .open {
                                HStack {
                                    Button("Resolve") {
                                        store.resolveDispute(dispute)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    Button("Escalate") {
                                        store.escalateDispute(dispute)
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Trust Rules") {
                    ForEach(store.trustRules, id: \.self) { rule in
                        Label(rule, systemImage: "checkmark.shield")
                    }
                }

                Section("Ops Notes") {
                    ForEach(store.operatorNotes, id: \.self) { note in
                        Label(note, systemImage: "arrow.right.circle")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Trust")
        }
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

struct MarketplaceListingRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let category: String
    let seller: String
    let price: Double
    let rating: Double
    let shippingLabel: String
    var stockCount: Int
    let description: String
    var isWishlisted: Bool
    var isReserved: Bool
}

struct MarketplaceCartItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let listingTitle: String
    let seller: String
    let price: Double
    var quantity: Int
}

enum MarketplaceQueueStatus: Hashable, Sendable {
    case ready
    case needsReview
    case blocked

    var label: String {
        switch self {
        case .ready:
            return "Ready"
        case .needsReview:
            return "Needs review"
        case .blocked:
            return "Blocked"
        }
    }

    var color: Color {
        switch self {
        case .ready:
            return .green
        case .needsReview:
            return .orange
        case .blocked:
            return .red
        }
    }
}

struct MarketplaceSellerQueueRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    var status: MarketplaceQueueStatus
}

struct MarketplacePayoutRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let seller: String
    let amount: Double
    var window: String
    var isHeld: Bool
}

enum MarketplaceOrderStatus: Hashable, Sendable {
    case processing
    case packed
    case shipped
    case delivered
    case manualReview

    var label: String {
        switch self {
        case .processing:
            return "Processing"
        case .packed:
            return "Packed"
        case .shipped:
            return "Shipped"
        case .delivered:
            return "Delivered"
        case .manualReview:
            return "Manual review"
        }
    }
}

struct MarketplaceOrderRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let seller: String
    var status: MarketplaceOrderStatus
    var shippingWindow: String
    let total: Double
    var supportNotes: [String]
    var supportStatus: String
}

enum MarketplaceDisputeLevel: Hashable, Sendable {
    case medium
    case high

    var label: String {
        switch self {
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }

    var color: Color {
        switch self {
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

enum MarketplaceDisputeStatus: Hashable, Sendable {
    case open
    case escalated
    case resolved

    var label: String {
        switch self {
        case .open:
            return "Open"
        case .escalated:
            return "Escalated"
        case .resolved:
            return "Resolved"
        }
    }

    var color: Color {
        switch self {
        case .open:
            return .red
        case .escalated:
            return .indigo
        case .resolved:
            return .green
        }
    }
}

struct MarketplaceDisputeRecord: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let level: MarketplaceDisputeLevel
    var status: MarketplaceDisputeStatus
}

private extension Double {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "$0"
    }
}
