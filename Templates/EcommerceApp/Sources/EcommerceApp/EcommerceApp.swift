import SwiftUI

@main
struct EcommerceApp: App {
    var body: some Scene {
        WindowGroup {
            EcommerceRuntimeRootView()
        }
    }
}

struct EcommerceRuntimeRootView: View {
    @StateObject private var store = CommerceStore()

    var body: some View {
        TabView {
            CommerceHomeView(store: store)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Shop")
                }

            CommerceCatalogView(store: store)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Browse")
                }

            CommerceCartView(store: store)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }

            CommerceOrdersView(store: store)
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Orders")
                }

            CommerceProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

@MainActor
final class CommerceStore: ObservableObject {
    @Published var categories: [CommerceCategory] = CommerceCategory.sampleCategories
    @Published var products: [CommerceProduct] = CommerceProduct.sampleProducts
    @Published var cartItems: [CommerceCartItem] = []
    @Published var placedOrders: [CommerceOrder] = CommerceOrder.sampleOrders
    @Published var selectedCategoryID: UUID?
    @Published var selectedAddressID: UUID?
    @Published var selectedPaymentID: UUID?
    @Published var appliedCouponCode = ""
    @Published var checkoutNotice = "Orders placed before 21:00 ship same day from the Istanbul fulfillment lane."
    @Published var wishlistIDs: Set<UUID> = []
    @Published var selectedDeliveryWindow = "Tomorrow • 18:00-21:00"

    let savedAddresses: [CommerceAddress] = CommerceAddress.sampleAddresses
    let paymentMethods: [CommercePaymentMethod] = CommercePaymentMethod.sampleMethods
    let deliveryWindows = ["Tomorrow • 12:00-15:00", "Tomorrow • 18:00-21:00", "Friday • 10:00-13:00"]

    init() {
        selectedCategoryID = categories.first?.id
        selectedAddressID = savedAddresses.first?.id
        selectedPaymentID = paymentMethods.first?.id
        seedCart()
    }

    var featuredProducts: [CommerceProduct] {
        products.filter(\.isFeatured)
    }

    var selectedCategory: CommerceCategory? {
        categories.first(where: { $0.id == selectedCategoryID }) ?? categories.first
    }

    var visibleProducts: [CommerceProduct] {
        guard let selectedCategoryID else { return products }
        return products.filter { $0.categoryID == selectedCategoryID }
    }

    var subtotal: Double {
        cartItems.reduce(0) { partial, item in
            partial + (item.product.price * Double(item.quantity))
        }
    }

    var savings: Double {
        appliedCouponCode == "SPRINT10" ? subtotal * 0.1 : 0
    }

    var shippingFee: Double {
        subtotal >= 150 ? 0 : 12.99
    }

    var taxes: Double {
        max(0, (subtotal - savings) * 0.08)
    }

    var total: Double {
        max(0, subtotal - savings + shippingFee + taxes)
    }

    var selectedAddress: CommerceAddress? {
        savedAddresses.first(where: { $0.id == selectedAddressID }) ?? savedAddresses.first
    }

    var selectedPaymentMethod: CommercePaymentMethod? {
        paymentMethods.first(where: { $0.id == selectedPaymentID }) ?? paymentMethods.first
    }

    func selectCategory(_ categoryID: UUID) {
        selectedCategoryID = categoryID
    }

    func toggleWishlist(_ productID: UUID) {
        if wishlistIDs.contains(productID) {
            wishlistIDs.remove(productID)
        } else {
            wishlistIDs.insert(productID)
        }
    }

    func addToCart(_ productID: UUID) {
        guard let product = products.first(where: { $0.id == productID }) else { return }

        if let itemIndex = cartItems.firstIndex(where: { $0.product.id == productID }) {
            cartItems[itemIndex].quantity += 1
        } else {
            cartItems.append(.init(product: product, quantity: 1))
        }
    }

    func incrementCartItem(_ itemID: UUID) {
        guard let itemIndex = cartItems.firstIndex(where: { $0.id == itemID }) else { return }
        cartItems[itemIndex].quantity += 1
    }

    func decrementCartItem(_ itemID: UUID) {
        guard let itemIndex = cartItems.firstIndex(where: { $0.id == itemID }) else { return }
        cartItems[itemIndex].quantity -= 1
        if cartItems[itemIndex].quantity <= 0 {
            cartItems.remove(at: itemIndex)
        }
    }

    func applyCoupon(_ code: String) {
        let normalized = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !normalized.isEmpty else { return }
        appliedCouponCode = normalized == "SPRINT10" ? normalized : ""
    }

    func selectAddress(_ addressID: UUID) {
        selectedAddressID = addressID
    }

    func selectPaymentMethod(_ paymentID: UUID) {
        selectedPaymentID = paymentID
    }

    func selectDeliveryWindow(_ window: String) {
        selectedDeliveryWindow = window
        checkoutNotice = "Delivery window updated to \(window). Fulfillment will lock after payment and address checks."
    }

    func placeOrder() {
        guard !cartItems.isEmpty,
              let address = selectedAddress,
              let payment = selectedPaymentMethod else {
            return
        }

        let statusTrail = [
            CommerceOrderStatusEvent(title: "Confirmed", detail: "Payment authorized with \(payment.label).", state: .completed),
            CommerceOrderStatusEvent(title: "Packed", detail: "Items routed into same-day fulfillment.", state: .completed),
            CommerceOrderStatusEvent(title: "Shipped", detail: "Courier assigned for \(address.city) delivery.", state: .active),
            CommerceOrderStatusEvent(title: "Delivered", detail: "Expected tomorrow before 19:00.", state: .pending)
        ]

        let order = CommerceOrder(
            title: "Order #\(1000 + placedOrders.count + 1)",
            summary: "Placed \(cartItems.count) items for \(address.label) with \(payment.label) in the \(selectedDeliveryWindow) lane.",
            total: total,
            statusHeadline: "Awaiting courier dispatch",
            timeline: statusTrail,
            items: cartItems,
            shipmentETA: selectedDeliveryWindow,
            supportAction: "Open courier issue",
            supportStatus: "Healthy"
        )

        placedOrders.insert(order, at: 0)
        cartItems.removeAll()
        appliedCouponCode = ""
    }

    func reorder(_ orderID: UUID) {
        guard let order = placedOrders.first(where: { $0.id == orderID }) else { return }
        cartItems = order.items
    }

    func advanceOrder(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        let activeIndex = placedOrders[index].timeline.firstIndex(where: { $0.state == .active })

        if let activeIndex {
            placedOrders[index].timeline[activeIndex].state = .completed
            if activeIndex + 1 < placedOrders[index].timeline.count {
                placedOrders[index].timeline[activeIndex + 1].state = .active
                placedOrders[index].statusHeadline = placedOrders[index].timeline[activeIndex + 1].title
                placedOrders[index].shipmentETA = activeIndex + 1 == placedOrders[index].timeline.count - 1 ? "Today before 21:00" : "Courier update pending"
            } else {
                placedOrders[index].statusHeadline = "Delivered"
                placedOrders[index].shipmentETA = "Delivered"
            }
        }
    }

    func confirmDelivery(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        for timelineIndex in placedOrders[index].timeline.indices {
            placedOrders[index].timeline[timelineIndex].state = .completed
        }
        placedOrders[index].statusHeadline = "Delivered"
        placedOrders[index].shipmentETA = "Delivered now"
        placedOrders[index].supportStatus = "Post-purchase window active"
    }

    func openSupportIssue(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        placedOrders[index].supportStatus = "Courier issue opened"
        placedOrders[index].supportAction = "Resolve courier issue"
        checkoutNotice = "Support case opened for \(placedOrders[index].title)."
    }

    func resolveSupportIssue(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        placedOrders[index].supportStatus = "Support resolved"
        placedOrders[index].supportAction = "Reorder Items"
        checkoutNotice = "Support issue resolved and post-purchase state is healthy again."
    }

    private func seedCart() {
        guard let first = products.first, let second = products.dropFirst().first else { return }
        cartItems = [
            CommerceCartItem(product: first, quantity: 1),
            CommerceCartItem(product: second, quantity: 2)
        ]
        wishlistIDs = [first.id]
    }
}

struct CommerceHomeView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CommerceHeroCard(store: store)
                    CommerceCategoryStrip(store: store)
                    CommerceFeaturedSection(store: store)
                    CommerceServiceSurface(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Shop")
        }
    }
}

struct CommerceHeroCard: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Commerce Pulse")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.cartItems.isEmpty ? "Your cart is clear. Build the next order with one fast checkout path." : "Your current cart is ready for same-day fulfillment.")
                .font(.system(size: 30, weight: .bold, design: .rounded))

            Text(store.checkoutNotice)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                CommerceMetricChip(title: "Items", value: "\(store.cartItems.count)")
                CommerceMetricChip(title: "Wishlist", value: "\(store.wishlistIDs.count)")
                CommerceMetricChip(title: "Orders", value: "\(store.placedOrders.count)")
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.18), .red.opacity(0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

struct CommerceMetricChip: View {
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

struct CommerceCategoryStrip: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Collections")
                .font(.title3.weight(.bold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(store.categories) { category in
                        Button {
                            store.selectCategory(category.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Image(systemName: category.icon)
                                    .font(.title3)
                                Text(category.title)
                                    .font(.subheadline.weight(.semibold))
                                Text(category.tagline)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            .frame(width: 160, alignment: .leading)
                            .padding()
                            .background(store.selectedCategoryID == category.id ? Color.orange.opacity(0.18) : Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct CommerceFeaturedSection: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Picks")
                .font(.title3.weight(.bold))

            ForEach(store.featuredProducts) { product in
                NavigationLink {
                    CommerceProductDetailView(store: store, productID: product.id)
                } label: {
                    CommerceProductCard(product: product, isWishlisted: store.wishlistIDs.contains(product.id))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct CommerceProductCard: View {
    let product: CommerceProduct
    let isWishlisted: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(product.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: isWishlisted ? "heart.fill" : "heart")
                    .foregroundStyle(.orange)
            }

            Text(product.heroBenefit)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Text(product.price.currencyString)
                    .font(.headline)
                Spacer()
                Text(product.shippingETA)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CommerceServiceSurface: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Buyer Confidence")
                .font(.title3.weight(.bold))

            ForEach(CommerceTrustSignal.sampleSignals) { signal in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: signal.icon)
                        .foregroundStyle(signal.tint)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(signal.title)
                            .font(.headline)
                        Text(signal.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

struct CommerceCatalogView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.visibleProducts) { product in
                    NavigationLink {
                        CommerceProductDetailView(store: store, productID: product.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(product.title)
                                    .font(.headline)
                                Spacer()
                                Text(product.price.currencyString)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Text(product.subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(product.rating, specifier: "%.1f")★ • \(product.reviewCount) reviews • \(product.shippingETA)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(store.selectedCategory?.title ?? "Browse")
        }
    }
}

struct CommerceProductDetailView: View {
    @ObservedObject var store: CommerceStore
    let productID: UUID

    private var product: CommerceProduct? {
        store.products.first(where: { $0.id == productID })
    }

    var body: some View {
        Group {
            if let product {
                List {
                    Section("Product") {
                        Text(product.title)
                            .font(.title3.weight(.bold))
                        Text(product.subtitle)
                            .foregroundStyle(.secondary)
                        Text(product.heroBenefit)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Label(product.price.currencyString, systemImage: "creditcard.fill")
                        Label(product.shippingETA, systemImage: "truck.box.fill")
                        Label("\(product.stockStatus)", systemImage: "shippingbox.fill")
                    }

                    Section("Variants") {
                        ForEach(product.variants, id: \.self) { variant in
                            Label(variant, systemImage: "circle.grid.2x2.fill")
                        }
                    }

                    Section("Proof") {
                        Label("\(product.rating, specifier: "%.1f") average rating", systemImage: "star.fill")
                        Label("\(product.reviewCount) customer reviews", systemImage: "bubble.left.and.bubble.right.fill")
                        Label(product.returnPolicy, systemImage: "arrow.uturn.backward.circle.fill")
                    }

                    Section("Actions") {
                        Button(store.wishlistIDs.contains(product.id) ? "Remove From Wishlist" : "Save To Wishlist") {
                            store.toggleWishlist(product.id)
                        }
                        Button("Add To Cart") {
                            store.addToCart(product.id)
                        }
                        .foregroundStyle(.orange)
                    }
                }
                .navigationTitle("Product Detail")
            } else {
                ContentUnavailableView("Product unavailable", systemImage: "bag")
            }
        }
    }
}

struct CommerceCartView: View {
    @ObservedObject var store: CommerceStore
    @State private var couponDraft = ""

    var body: some View {
        NavigationStack {
            List {
                if store.cartItems.isEmpty {
                    ContentUnavailableView(
                        "Cart is empty",
                        systemImage: "cart",
                        description: Text("Add products from the catalog to open the checkout path.")
                    )
                } else {
                    Section("Items") {
                        ForEach(store.cartItems) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(item.product.title)
                                        .font(.headline)
                                    Spacer()
                                    Text(item.product.price.currencyString)
                                        .font(.subheadline.weight(.semibold))
                                }
                                Text(item.product.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    Button {
                                        store.decrementCartItem(item.id)
                                    } label: {
                                        Image(systemName: "minus.circle.fill")
                                    }

                                    Text("Qty \(item.quantity)")
                                        .font(.subheadline.weight(.semibold))

                                    Button {
                                        store.incrementCartItem(item.id)
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                    }

                                    Spacer()
                                    Text((item.product.price * Double(item.quantity)).currencyString)
                                        .font(.subheadline.weight(.semibold))
                                }
                                .foregroundStyle(.orange)
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section("Coupon") {
                        TextField("Enter code", text: $couponDraft)
                        Button("Apply Coupon") {
                            store.applyCoupon(couponDraft)
                            couponDraft = ""
                        }
                        .buttonStyle(.bordered)
                        if !store.appliedCouponCode.isEmpty {
                            Label("\(store.appliedCouponCode) applied", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        }
                    }

                    Section("Checkout") {
                        NavigationLink {
                            CommerceCheckoutView(store: store)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Open checkout")
                                    .font(.headline)
                                Text("Review address, payment, savings, and shipping before placing the order.")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cart")
        }
    }
}

struct CommerceCheckoutView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        List {
            Section("Shipping Address") {
                ForEach(store.savedAddresses) { address in
                    Button {
                        store.selectAddress(address.id)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(address.label)
                                    .foregroundStyle(.primary)
                                Text(address.summary)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: store.selectedAddressID == address.id ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(store.selectedAddressID == address.id ? .orange : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Payment") {
                ForEach(store.paymentMethods) { method in
                    Button {
                        store.selectPaymentMethod(method.id)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(method.label)
                                    .foregroundStyle(.primary)
                                Text(method.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: store.selectedPaymentID == method.id ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(store.selectedPaymentID == method.id ? .orange : .secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Summary") {
                Picker("Delivery Window", selection: $store.selectedDeliveryWindow) {
                    ForEach(store.deliveryWindows, id: \.self) { window in
                        Text(window).tag(window)
                    }
                }
                .onChange(of: store.selectedDeliveryWindow) { _, newValue in
                    store.selectDeliveryWindow(newValue)
                }
                CommerceSummaryRow(title: "Subtotal", value: store.subtotal.currencyString)
                CommerceSummaryRow(title: "Savings", value: "-\(store.savings.currencyString)")
                CommerceSummaryRow(title: "Shipping", value: store.shippingFee == 0 ? "Free" : store.shippingFee.currencyString)
                CommerceSummaryRow(title: "Taxes", value: store.taxes.currencyString)
                CommerceSummaryRow(title: "Total", value: store.total.currencyString, isPrimary: true)
            }

            Section("Action") {
                Text(store.checkoutNotice)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button("Place Order") {
                    store.placeOrder()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
        }
        .navigationTitle("Checkout")
    }
}

struct CommerceSummaryRow: View {
    let title: String
    let value: String
    var isPrimary = false

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .font(isPrimary ? .headline : .body)
                .foregroundStyle(isPrimary ? .orange : .primary)
        }
    }
}

struct CommerceOrdersView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.placedOrders) { order in
                    NavigationLink {
                        CommerceOrderDetailView(store: store, orderID: order.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(order.title)
                                .font(.headline)
                            Text(order.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("\(order.total.currencyString) • ETA \(order.shipmentETA)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

struct CommerceOrderDetailView: View {
    @ObservedObject var store: CommerceStore
    let orderID: UUID

    private var order: CommerceOrder? {
        store.placedOrders.first(where: { $0.id == orderID })
    }

    var body: some View {
        Group {
            if let order {
                List {
                    Section("Order") {
                        Text(order.title)
                            .font(.title3.weight(.bold))
                        Text(order.summary)
                            .foregroundStyle(.secondary)
                        Label(order.statusHeadline, systemImage: "shippingbox.fill")
                        Label(order.total.currencyString, systemImage: "creditcard.fill")
                        Label(order.shipmentETA, systemImage: "clock.badge.checkmark.fill")
                        Label(order.supportStatus, systemImage: "lifepreserver.fill")
                    }

                    Section("Timeline") {
                        ForEach(order.timeline) { event in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: event.state.icon)
                                    .foregroundStyle(event.state.tint)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(event.title)
                                        .font(.headline)
                                    Text(event.detail)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section("Items") {
                        ForEach(order.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.product.title)
                                    Text("Qty \(item.quantity)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text((item.product.price * Double(item.quantity)).currencyString)
                            }
                        }
                    }

                    Section("Actions") {
                        Button("Advance Fulfillment") {
                            store.advanceOrder(order.id)
                        }
                        .disabled(order.statusHeadline == "Delivered")

                        Button("Confirm Delivery") {
                            store.confirmDelivery(order.id)
                        }
                        .disabled(order.statusHeadline == "Delivered")

                        Button(order.supportAction) {
                            if order.supportAction == "Open courier issue" {
                                store.openSupportIssue(order.id)
                            } else if order.supportAction == "Resolve courier issue" {
                                store.resolveSupportIssue(order.id)
                            } else {
                                store.reorder(order.id)
                            }
                        }
                            .foregroundStyle(.orange)
                    }
                }
                .navigationTitle("Order Detail")
            } else {
                ContentUnavailableView("Order unavailable", systemImage: "shippingbox")
            }
        }
    }
}

struct CommerceProfileView: View {
    @ObservedObject var store: CommerceStore

    var body: some View {
        NavigationStack {
            List {
                Section("Buyer") {
                    Label("Mina Aksoy", systemImage: "person.crop.circle.fill")
                    Label("Express delivery eligible", systemImage: "bolt.fill")
                }

                Section("Commerce Rules") {
                    Label("Same-day shipping starts before 21:00", systemImage: "clock.fill")
                    Label("Coupon `SPRINT10` unlocks a 10% cart discount", systemImage: "tag.fill")
                    Label("Post-purchase support opens from order detail", systemImage: "lifepreserver.fill")
                }

                Section("Saved Surfaces") {
                    if let address = store.selectedAddress {
                        Label(address.label, systemImage: "house.fill")
                    }
                    if let payment = store.selectedPaymentMethod {
                        Label(payment.label, systemImage: "creditcard.fill")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct CommerceCategory: Identifiable, Hashable {
    let id: UUID
    let title: String
    let tagline: String
    let icon: String

    init(id: UUID = UUID(), title: String, tagline: String, icon: String) {
        self.id = id
        self.title = title
        self.tagline = tagline
        self.icon = icon
    }

    static let sampleCategories: [CommerceCategory] = [
        .init(title: "Desk Setup", tagline: "Performance gear for deep work and clean shipping.", icon: "laptopcomputer"),
        .init(title: "Carry", tagline: "Travel-ready accessories with fast reorder paths.", icon: "suitcase.rolling.fill"),
        .init(title: "Audio", tagline: "Premium listening gear with buyer proof and returns.", icon: "headphones")
    ]
}

struct CommerceProduct: Identifiable, Hashable {
    let id: UUID
    let categoryID: UUID
    let title: String
    let subtitle: String
    let heroBenefit: String
    let price: Double
    let shippingETA: String
    let stockStatus: String
    let rating: Double
    let reviewCount: Int
    let variants: [String]
    let returnPolicy: String
    let isFeatured: Bool

    init(
        id: UUID = UUID(),
        categoryID: UUID,
        title: String,
        subtitle: String,
        heroBenefit: String,
        price: Double,
        shippingETA: String,
        stockStatus: String,
        rating: Double,
        reviewCount: Int,
        variants: [String],
        returnPolicy: String,
        isFeatured: Bool
    ) {
        self.id = id
        self.categoryID = categoryID
        self.title = title
        self.subtitle = subtitle
        self.heroBenefit = heroBenefit
        self.price = price
        self.shippingETA = shippingETA
        self.stockStatus = stockStatus
        self.rating = rating
        self.reviewCount = reviewCount
        self.variants = variants
        self.returnPolicy = returnPolicy
        self.isFeatured = isFeatured
    }

    static let sampleProducts: [CommerceProduct] = {
        let categories = CommerceCategory.sampleCategories
        return [
            .init(
                categoryID: categories[0].id,
                title: "Arc Desk Lamp",
                subtitle: "Ambient task light with focused warm-cool control.",
                heroBenefit: "Cuts evening glare without flattening your workspace contrast.",
                price: 89.0,
                shippingETA: "Ships today",
                stockStatus: "In stock",
                rating: 4.8,
                reviewCount: 241,
                variants: ["Matte black", "Soft silver"],
                returnPolicy: "30-day free returns and prepaid label.",
                isFeatured: true
            ),
            .init(
                categoryID: categories[0].id,
                title: "Focus Mat",
                subtitle: "Desk mat with cable pass-through and spill resistance.",
                heroBenefit: "Stabilizes your work area and keeps keyboard noise down.",
                price: 32.0,
                shippingETA: "Ships tomorrow",
                stockStatus: "Low stock",
                rating: 4.6,
                reviewCount: 119,
                variants: ["Graphite", "Sand", "Olive"],
                returnPolicy: "14-day exchanges on unused mats.",
                isFeatured: false
            ),
            .init(
                categoryID: categories[1].id,
                title: "Transit Sling",
                subtitle: "Daily carry bag with hidden passport and charger lanes.",
                heroBenefit: "Moves quickly through airport and commuter transitions.",
                price: 124.0,
                shippingETA: "Ships today",
                stockStatus: "In stock",
                rating: 4.9,
                reviewCount: 312,
                variants: ["Coal", "Navy"],
                returnPolicy: "30-day returns with courier pickup.",
                isFeatured: true
            ),
            .init(
                categoryID: categories[2].id,
                title: "Studio Buds Pro",
                subtitle: "Noise control earbuds tuned for calls and editing.",
                heroBenefit: "Maintains clean voice clarity in loud indoor lanes.",
                price: 149.0,
                shippingETA: "Ships today",
                stockStatus: "In stock",
                rating: 4.7,
                reviewCount: 198,
                variants: ["Onyx", "Stone"],
                returnPolicy: "30-day audio fit guarantee.",
                isFeatured: true
            )
        ]
    }()
}

struct CommerceCartItem: Identifiable, Hashable {
    let id: UUID
    let product: CommerceProduct
    var quantity: Int

    init(id: UUID = UUID(), product: CommerceProduct, quantity: Int) {
        self.id = id
        self.product = product
        self.quantity = quantity
    }
}

struct CommerceAddress: Identifiable, Hashable {
    let id: UUID
    let label: String
    let city: String
    let summary: String

    init(id: UUID = UUID(), label: String, city: String, summary: String) {
        self.id = id
        self.label = label
        self.city = city
        self.summary = summary
    }

    static let sampleAddresses: [CommerceAddress] = [
        .init(label: "Home", city: "Istanbul", summary: "Acibadem, Kadikoy • door delivery between 14:00-19:00"),
        .init(label: "Studio", city: "Istanbul", summary: "Levent, Besiktas • business hours drop-off")
    ]
}

struct CommercePaymentMethod: Identifiable, Hashable {
    let id: UUID
    let label: String
    let detail: String

    init(id: UUID = UUID(), label: String, detail: String) {
        self.id = id
        self.label = label
        self.detail = detail
    }

    static let sampleMethods: [CommercePaymentMethod] = [
        .init(label: "Visa •••• 1842", detail: "Primary card with instant refund support"),
        .init(label: "Apple Pay", detail: "Fast checkout with device auth")
    ]
}

enum CommerceTimelineState: Hashable {
    case completed
    case active
    case pending

    var icon: String {
        switch self {
        case .completed:
            return "checkmark.circle.fill"
        case .active:
            return "shippingbox.fill"
        case .pending:
            return "circle"
        }
    }

    var tint: Color {
        switch self {
        case .completed:
            return .green
        case .active:
            return .orange
        case .pending:
            return .secondary
        }
    }
}

struct CommerceOrderStatusEvent: Identifiable, Hashable {
    let id: UUID
    let title: String
    let detail: String
    var state: CommerceTimelineState

    init(id: UUID = UUID(), title: String, detail: String, state: CommerceTimelineState) {
        self.id = id
        self.title = title
        self.detail = detail
        self.state = state
    }
}

struct CommerceOrder: Identifiable, Hashable {
    let id: UUID
    let title: String
    let summary: String
    let total: Double
    var statusHeadline: String
    var timeline: [CommerceOrderStatusEvent]
    let items: [CommerceCartItem]
    var shipmentETA: String
    var supportAction: String
    var supportStatus: String

    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        total: Double,
        statusHeadline: String,
        timeline: [CommerceOrderStatusEvent],
        items: [CommerceCartItem],
        shipmentETA: String,
        supportAction: String,
        supportStatus: String
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.total = total
        self.statusHeadline = statusHeadline
        self.timeline = timeline
        self.items = items
        self.shipmentETA = shipmentETA
        self.supportAction = supportAction
        self.supportStatus = supportStatus
    }

    static let sampleOrders: [CommerceOrder] = {
        let products = CommerceProduct.sampleProducts
        let items = [
            CommerceCartItem(product: products[0], quantity: 1),
            CommerceCartItem(product: products[2], quantity: 1)
        ]

        return [
            CommerceOrder(
                title: "Order #1001",
                summary: "Two-item workstation upgrade currently moving through the courier lane.",
                total: 213.0,
                statusHeadline: "Shipped",
                timeline: [
                    .init(title: "Confirmed", detail: "Payment cleared instantly with Visa.", state: .completed),
                    .init(title: "Packed", detail: "Warehouse packed both items with protection inserts.", state: .completed),
                    .init(title: "Shipped", detail: "Courier accepted the route at 17:40.", state: .active),
                    .init(title: "Delivered", detail: "Expected tomorrow by 18:30.", state: .pending)
                ],
                items: items,
                shipmentETA: "Tomorrow 18:30",
                supportAction: "Open courier issue",
                supportStatus: "Healthy"
            )
        ]
    }()
}

struct CommerceTrustSignal: Identifiable, Hashable {
    let id: UUID
    let title: String
    let detail: String
    let icon: String
    let tint: Color

    init(id: UUID = UUID(), title: String, detail: String, icon: String, tint: Color) {
        self.id = id
        self.title = title
        self.detail = detail
        self.icon = icon
        self.tint = tint
    }

    static let sampleSignals: [CommerceTrustSignal] = [
        .init(title: "Fast refunds", detail: "Refund reviews start from the order detail without external support hops.", icon: "arrow.uturn.backward.circle.fill", tint: .green),
        .init(title: "Delivery confidence", detail: "Checkout ETA is tied to the selected address and same-day lane availability.", icon: "truck.box.fill", tint: .orange),
        .init(title: "Buyer proof", detail: "Every featured product exposes review count, return policy, and stock status on the PDP.", icon: "checkmark.shield.fill", tint: .blue)
    ]
}

private extension Double {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
