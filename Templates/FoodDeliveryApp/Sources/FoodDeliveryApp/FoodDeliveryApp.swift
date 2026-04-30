import Foundation
import SwiftUI
import FoodDeliveryAppCore

private enum FoodDeliveryInteractionProofMode {
    static let isEnabled = ProcessInfo.processInfo.environment["IOSAPPTEMPLATES_INTERACTION_PROOF_MODE"] == "1"

    static func write(summary: String, steps: [String]) {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }

        let payload: [String: Any] = [
            "app": "FoodDeliveryApp",
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

public struct FoodDeliveryAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            FoodDeliveryRuntimeRootView()
        }
    }
}

struct FoodDeliveryRuntimeRootView: View {
    @StateObject private var store = FoodDeliveryOperationsStore()

    var body: some View {
        TabView {
            FoodDeliveryDashboardView(store: store)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            FoodDeliveryBrowseView(store: store)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Browse")
                }

            FoodDeliveryCartView(store: store)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }

            FoodDeliveryOrdersView(store: store)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Orders")
                }

            FoodDeliveryProfileView(store: store)
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.orange)
        .onAppear {
            store.runInteractionProofIfNeeded()
        }
    }
}

@MainActor
final class FoodDeliveryOperationsStore: ObservableObject {
    @Published var restaurants: [DeliveryRestaurantRecord] = DeliveryRestaurantRecord.sampleRestaurants
    @Published var cartItems: [DeliveryCartItemRecord] = DeliveryCartItemRecord.sampleCart
    @Published var liveOrder: DeliveryOrderRecord = .sampleLive
    @Published var pastOrders: [DeliveryOrderRecord] = DeliveryOrderRecord.samplePast
    @Published var selectedRestaurantID: UUID?
    @Published var selectedDeliverySlot = "Tonight • 19:40"
    @Published var appliedPromoCode = ""
    @Published var membershipTier = "Plus"
    @Published var deliveryAddress = "Moda, Kadikoy"
    @Published var paymentMethod = "Visa •••• 4021"
    @Published var operatorNote = "Checkout should only lock after item totals, promo, payment, and courier window are aligned."
    private var interactionProofScheduled = false
    let deliverySlots = ["Tonight • 19:40", "Tonight • 20:10", "Tomorrow • 12:30"]
    let paymentMethods = ["Visa •••• 4021", "Mastercard •••• 8714", "Apple Pay"]

    init() {
        selectedRestaurantID = restaurants.first?.id
    }

    var selectedRestaurant: DeliveryRestaurantRecord? {
        restaurants.first(where: { $0.id == selectedRestaurantID }) ?? restaurants.first
    }

    var featuredRestaurants: [DeliveryRestaurantRecord] {
        Array(restaurants.prefix(3))
    }

    var subtotal: Double {
        cartItems.reduce(0) { $0 + (Double($1.quantity) * $1.unitPrice) }
    }

    var deliveryFee: Double {
        selectedRestaurant?.deliveryFee ?? 1.99
    }

    var serviceFee: Double {
        subtotal * 0.05
    }

    var promoSavings: Double {
        appliedPromoCode == "DINNER6" ? 6 : 0
    }

    var total: Double {
        max(0, subtotal + deliveryFee + serviceFee - promoSavings)
    }

    var monthlySavings: String {
        "$\(48 + (appliedPromoCode.isEmpty ? 0 : 6))"
    }

    var dashboardHeadline: String {
        if liveOrder.progress < 1 {
            return "\(liveOrder.status) and the courier wave is still active."
        }
        if cartItems.isEmpty {
            return "Cart is empty. Build the next order before the evening peak."
        }
        return "Checkout is almost ready and promo coverage is available."
    }

    func selectRestaurant(_ id: UUID) {
        selectedRestaurantID = id
    }

    func addMenuItem(_ item: DeliveryMenuItemRecord, from restaurant: DeliveryRestaurantRecord) {
        if let index = cartItems.firstIndex(where: { $0.menuItemID == item.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(
                DeliveryCartItemRecord(menuItemID: item.id, name: item.name, restaurant: restaurant.name, quantity: 1, unitPrice: item.price)
            )
        }
    }

    func incrementCartItem(_ id: UUID) {
        guard let index = cartItems.firstIndex(where: { $0.id == id }) else { return }
        cartItems[index].quantity += 1
    }

    func decrementCartItem(_ id: UUID) {
        guard let index = cartItems.firstIndex(where: { $0.id == id }) else { return }
        cartItems[index].quantity -= 1
        if cartItems[index].quantity <= 0 {
            cartItems.remove(at: index)
        }
    }

    func applyPromo(_ code: String) {
        let normalized = code.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        guard !normalized.isEmpty else { return }
        appliedPromoCode = normalized == "DINNER6" ? normalized : ""
    }

    func selectDeliverySlot(_ slot: String) {
        selectedDeliverySlot = slot
        operatorNote = "Delivery slot moved to \(slot). Courier assignment will follow slot lock."
    }

    func selectPaymentMethod(_ method: String) {
        paymentMethod = method
    }

    func placeOrder() {
        guard !cartItems.isEmpty, let restaurant = selectedRestaurant else { return }

        liveOrder = DeliveryOrderRecord(
            restaurantName: restaurant.name,
            status: "Order confirmed",
            eta: "24 min",
            courierName: "Mert",
            total: total,
            progress: 0.2,
            timeline: [
                "Order confirmed",
                "Kitchen accepted the ticket",
                "Courier assignment pending",
                "Courier pickup pending"
            ],
            supportStatus: "Healthy"
        )

        pastOrders.insert(liveOrder, at: 0)
        cartItems.removeAll()
        appliedPromoCode = ""
    }

    func advanceLiveOrder() {
        switch liveOrder.status {
        case "Order confirmed":
            liveOrder.status = "Kitchen preparing"
            liveOrder.progress = 0.45
            liveOrder.timeline[1] = "Kitchen preparing"
        case "Kitchen preparing":
            liveOrder.status = "Courier picked up"
            liveOrder.progress = 0.72
            liveOrder.timeline[2] = "Courier assigned"
            liveOrder.timeline[3] = "Courier picked up"
        case "Courier picked up":
            liveOrder.status = "Courier arriving"
            liveOrder.progress = 0.9
            liveOrder.eta = "8 min"
        case "Courier arriving":
            liveOrder.status = "Delivered"
            liveOrder.progress = 1
            liveOrder.eta = "Delivered now"
        default:
            break
        }
        syncPastOrder()
    }

    func reportCourierIssue() {
        liveOrder.supportStatus = "Courier issue opened"
        liveOrder.status = "Support reviewing courier issue"
        liveOrder.timeline.append("Courier issue opened with support")
        operatorNote = "Courier issue escalated. ETA is being recalculated."
        syncPastOrder()
    }

    func recoverCourierIssue() {
        liveOrder.supportStatus = "Courier issue resolved"
        liveOrder.status = "Courier re-routed"
        liveOrder.eta = "14 min"
        liveOrder.progress = max(liveOrder.progress, 0.76)
        liveOrder.timeline.append("Courier issue resolved and route stabilized")
        operatorNote = "Courier route recovered and customer update sent."
        syncPastOrder()
    }

    func confirmDelivered() {
        liveOrder.status = "Delivered"
        liveOrder.eta = "Delivered now"
        liveOrder.progress = 1
        liveOrder.supportStatus = "Closed"
        if !liveOrder.timeline.contains("Delivered to customer") {
            liveOrder.timeline.append("Delivered to customer")
        }
        syncPastOrder()
    }

    func reorder(_ orderID: UUID) {
        guard let order = pastOrders.first(where: { $0.id == orderID }),
              let restaurant = restaurants.first(where: { $0.name == order.restaurantName }) else { return }
        selectedRestaurantID = restaurant.id
        cartItems = restaurant.menu.prefix(2).map {
            DeliveryCartItemRecord(menuItemID: $0.id, name: $0.name, restaurant: restaurant.name, quantity: 1, unitPrice: $0.price)
        }
    }

    private func syncPastOrder() {
        guard let index = pastOrders.firstIndex(where: { $0.id == liveOrder.id }) else { return }
        pastOrders[index] = liveOrder
    }

    func runInteractionProofIfNeeded() {
        guard FoodDeliveryInteractionProofMode.isEnabled, !interactionProofScheduled else { return }
        interactionProofScheduled = true

        DispatchQueue.main.async {
            var steps: [String] = []

            if let restaurant = self.restaurants.first {
                self.selectRestaurant(restaurant.id)
                steps.append("Selected restaurant")

                if let menuItem = restaurant.menu.first {
                    self.addMenuItem(menuItem, from: restaurant)
                    steps.append("Added menu item")
                }
            }

            if let cartItem = self.cartItems.first {
                self.incrementCartItem(cartItem.id)
                self.decrementCartItem(cartItem.id)
                steps.append("Adjusted cart quantity")
            }

            self.applyPromo("DINNER6")
            steps.append("Applied promo")

            if let slot = self.deliverySlots.last {
                self.selectDeliverySlot(slot)
                steps.append("Selected delivery slot")
            }

            if let method = self.paymentMethods.last {
                self.selectPaymentMethod(method)
                steps.append("Selected payment method")
            }

            self.placeOrder()
            steps.append("Placed order")

            self.advanceLiveOrder()
            self.reportCourierIssue()
            self.recoverCourierIssue()
            self.confirmDelivered()
            steps.append("Advanced live order and resolved courier issue")

            if let orderID = self.pastOrders.first?.id {
                self.reorder(orderID)
                steps.append("Triggered reorder")
            }

            FoodDeliveryInteractionProofMode.write(
                summary: "Delivery interaction proof completed with checkout, courier recovery, and reorder chain.",
                steps: steps
            )
        }
    }
}

struct FoodDeliveryDashboardView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FoodDeliveryHeroCard(store: store)
                    FoodDeliveryFeaturedRestaurantsView(store: store)
                    FoodDeliveryOrderStatusCard(store: store)
                    FoodDeliveryDealsCard(store: store)
                }
                .padding(16)
            }
            .navigationTitle("Delivery")
        }
    }
}

struct FoodDeliveryHeroCard: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tonight's Plan")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(store.dashboardHeadline)
                .font(.title2.weight(.bold))
            Text("Address: \(store.deliveryAddress) • Membership: \(store.membershipTier)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                FoodDeliveryMetricChip(title: "Restaurants", value: "\(store.restaurants.count)")
                FoodDeliveryMetricChip(title: "Cart", value: "\(store.cartItems.count)")
                FoodDeliveryMetricChip(title: "Savings", value: store.monthlySavings)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [.orange.opacity(0.16), .yellow.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}

struct FoodDeliveryMetricChip: View {
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

struct FoodDeliveryFeaturedRestaurantsView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Restaurants")
                .font(.title3.weight(.bold))

            ForEach(store.featuredRestaurants) { restaurant in
                NavigationLink {
                    FoodDeliveryRestaurantDetailView(store: store, restaurantID: restaurant.id)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(restaurant.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("\(restaurant.cuisine) • \(restaurant.distance)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(restaurant.deliveryTime)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.orange)
                        }
                        HStack {
                            Label(restaurant.rating, systemImage: "star.fill")
                            Label(restaurant.deliveryFee.currencyString, systemImage: "scooter")
                            Label(restaurant.bestSeller, systemImage: "flame.fill")
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

struct FoodDeliveryOrderStatusCard: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live Order")
                .font(.title3.weight(.bold))

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(store.liveOrder.restaurantName)
                        .font(.headline)
                    Text(store.liveOrder.status)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)
                    Text("Courier: \(store.liveOrder.courierName) • \(store.liveOrder.eta)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(store.liveOrder.total.currencyString)
                    .font(.title3.weight(.bold))
            }

            ProgressView(value: store.liveOrder.progress)
                .tint(.orange)

            Button("Advance Live Order") {
                store.advanceLiveOrder()
            }
            .buttonStyle(.borderedProminent)
            .disabled(store.liveOrder.progress >= 1)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

struct FoodDeliveryDealsCard: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Deals")
                .font(.title3.weight(.bold))

            VStack(alignment: .leading, spacing: 8) {
                Text("DINNER6")
                    .font(.headline)
                Text("Apply $6 off dinner checkout once the cart is above the service floor.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button("Apply Promo") {
                    store.applyPromo("DINNER6")
                }
                .buttonStyle(.bordered)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct FoodDeliveryBrowseView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.restaurants) { restaurant in
                    NavigationLink {
                        FoodDeliveryRestaurantDetailView(store: store, restaurantID: restaurant.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(restaurant.name)
                                Spacer()
                                Text(restaurant.deliveryTime)
                                    .font(.subheadline.weight(.semibold))
                            }
                            Text("\(restaurant.cuisine) • \(restaurant.bestSeller)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Restaurants")
        }
    }
}

struct FoodDeliveryRestaurantDetailView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore
    let restaurantID: UUID

    var body: some View {
        if let restaurant = store.restaurants.first(where: { $0.id == restaurantID }) {
            List {
                Section("Restaurant") {
                    LabeledContent("Name", value: restaurant.name)
                    LabeledContent("Cuisine", value: restaurant.cuisine)
                    LabeledContent("Delivery Time", value: restaurant.deliveryTime)
                    LabeledContent("Delivery Fee", value: restaurant.deliveryFee.currencyString)
                }

                Section("Menu") {
                    ForEach(restaurant.menu) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.price.currencyString)
                            }
                            Text(item.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Button("Add to Cart") {
                                store.selectRestaurant(restaurant.id)
                                store.addMenuItem(item, from: restaurant)
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle(restaurant.name)
        }
    }
}

struct FoodDeliveryCartView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore
    @State private var promoDraft = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Cart Items") {
                    ForEach(store.cartItems) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.lineTotal.currencyString)
                                    .font(.headline.weight(.bold))
                            }
                            Text("\(item.quantity)x • \(item.restaurant)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack {
                                Button("-") { store.decrementCartItem(item.id) }
                                Button("+") { store.incrementCartItem(item.id) }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                Section("Promo") {
                    TextField("Promo code", text: $promoDraft)
                    Button("Apply Promo") {
                        store.applyPromo(promoDraft)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Section("Checkout") {
                    Picker("Delivery Slot", selection: $store.selectedDeliverySlot) {
                        ForEach(store.deliverySlots, id: \.self) { slot in
                            Text(slot).tag(slot)
                        }
                    }
                    .onChange(of: store.selectedDeliverySlot) { _, newValue in
                        store.selectDeliverySlot(newValue)
                    }
                    Picker("Payment", selection: $store.paymentMethod) {
                        ForEach(store.paymentMethods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    .onChange(of: store.paymentMethod) { _, newValue in
                        store.selectPaymentMethod(newValue)
                    }
                    LabeledContent("Subtotal", value: store.subtotal.currencyString)
                    LabeledContent("Delivery Fee", value: store.deliveryFee.currencyString)
                    LabeledContent("Service Fee", value: store.serviceFee.currencyString)
                    LabeledContent("Promo", value: "-\(store.promoSavings.currencyString)")
                    LabeledContent("Total", value: store.total.currencyString)
                    Button("Place Order") {
                        store.placeOrder()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.cartItems.isEmpty)
                }
            }
            .navigationTitle("Cart")
        }
    }
}

struct FoodDeliveryOrdersView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Live") {
                    NavigationLink {
                        FoodDeliveryOrderDetailView(store: store, orderID: store.liveOrder.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(store.liveOrder.restaurantName)
                            Text("\(store.liveOrder.status) • \(store.liveOrder.eta)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Past Orders") {
                    ForEach(store.pastOrders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            NavigationLink {
                                FoodDeliveryOrderDetailView(store: store, orderID: order.id)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(order.restaurantName)
                                    Text("\(order.status) • \(order.total.currencyString)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Button("Reorder") {
                                store.reorder(order.id)
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

struct FoodDeliveryOrderDetailView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore
    let orderID: UUID

    var body: some View {
        if let order = store.pastOrders.first(where: { $0.id == orderID }) {
            List {
                Section("Order") {
                    LabeledContent("Restaurant", value: order.restaurantName)
                    LabeledContent("Status", value: order.status)
                    LabeledContent("ETA", value: order.eta)
                    LabeledContent("Courier", value: order.courierName)
                    LabeledContent("Total", value: order.total.currencyString)
                    LabeledContent("Support", value: order.supportStatus)
                }

                Section("Timeline") {
                    ForEach(order.timeline, id: \.self) { step in
                        Label(step, systemImage: "clock.arrow.circlepath")
                    }
                }

                Section("Actions") {
                    if order.id == store.liveOrder.id {
                        Button("Advance Order") { store.advanceLiveOrder() }
                            .disabled(store.liveOrder.status == "Delivered")
                        Button("Report Courier Issue") { store.reportCourierIssue() }
                            .disabled(store.liveOrder.supportStatus == "Courier issue opened")
                        Button("Resolve Courier Issue") { store.recoverCourierIssue() }
                            .disabled(store.liveOrder.supportStatus != "Courier issue opened")
                        Button("Confirm Delivery") { store.confirmDelivered() }
                            .disabled(store.liveOrder.status == "Delivered")
                    }
                }
            }
            .navigationTitle("Order")
        }
    }
}

struct FoodDeliveryProfileView: View {
    @ObservedObject var store: FoodDeliveryOperationsStore

    var body: some View {
        NavigationStack {
            List {
                Section("Membership") {
                    LabeledContent("Tier", value: store.membershipTier)
                    LabeledContent("Delivery Address", value: store.deliveryAddress)
                    LabeledContent("Default Payment", value: store.paymentMethod)
                }

                Section("Habits") {
                    LabeledContent("Favorite Cuisine", value: store.selectedRestaurant?.cuisine ?? "Mediterranean")
                    LabeledContent("Monthly Savings", value: store.monthlySavings)
                    LabeledContent("Orders This Month", value: "\(store.pastOrders.count)")
                }

                Section("Operator Rule") {
                    Text(store.operatorNote)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct DeliveryRestaurantRecord: Identifiable {
    let id = UUID()
    let name: String
    let cuisine: String
    let distance: String
    let deliveryTime: String
    let deliveryFee: Double
    let rating: String
    let bestSeller: String
    let menu: [DeliveryMenuItemRecord]

    static let sampleRestaurants: [DeliveryRestaurantRecord] = [
        DeliveryRestaurantRecord(
            name: "Levant Kitchen",
            cuisine: "Mediterranean",
            distance: "1.2 km",
            deliveryTime: "18-24 min",
            deliveryFee: 1.99,
            rating: "4.8",
            bestSeller: "Chicken Shawarma Bowl",
            menu: [
                DeliveryMenuItemRecord(name: "Chicken Shawarma Bowl", price: 16.8, detail: "Rice, tahini, crunchy pickles, and warm pita."),
                DeliveryMenuItemRecord(name: "Hummus Trio", price: 8.1, detail: "Classic, spicy beet, and roasted pepper hummus."),
                DeliveryMenuItemRecord(name: "Pita Fries", price: 5.0, detail: "Za'atar fries with whipped feta dip.")
            ]
        ),
        DeliveryRestaurantRecord(
            name: "Zen Ramen Club",
            cuisine: "Japanese",
            distance: "2.4 km",
            deliveryTime: "22-30 min",
            deliveryFee: 2.49,
            rating: "4.7",
            bestSeller: "Spicy Tonkotsu",
            menu: [
                DeliveryMenuItemRecord(name: "Spicy Tonkotsu", price: 17.5, detail: "Rich broth, soft egg, pork belly, and chili oil."),
                DeliveryMenuItemRecord(name: "Gyoza", price: 7.4, detail: "Pan-seared dumplings with citrus soy."),
                DeliveryMenuItemRecord(name: "Miso Eggplant", price: 6.8, detail: "Roasted eggplant glazed in sweet miso.")
            ]
        ),
        DeliveryRestaurantRecord(
            name: "Daily Greens",
            cuisine: "Healthy",
            distance: "0.9 km",
            deliveryTime: "16-22 min",
            deliveryFee: 0.99,
            rating: "4.9",
            bestSeller: "Salmon Power Bowl",
            menu: [
                DeliveryMenuItemRecord(name: "Salmon Power Bowl", price: 15.9, detail: "Roasted salmon, quinoa, avocado, and lemon kale."),
                DeliveryMenuItemRecord(name: "Berry Protein Shake", price: 6.2, detail: "Mixed berry whey shake with almond milk."),
                DeliveryMenuItemRecord(name: "Avocado Crunch Salad", price: 11.5, detail: "Greens, seeds, feta, and crunchy chickpeas.")
            ]
        )
    ]
}

struct DeliveryMenuItemRecord: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let detail: String
}

struct DeliveryCartItemRecord: Identifiable {
    let id = UUID()
    let menuItemID: UUID
    let name: String
    let restaurant: String
    var quantity: Int
    let unitPrice: Double

    var lineTotal: Double { unitPrice * Double(quantity) }

    static let sampleCart: [DeliveryCartItemRecord] = {
        let restaurant = DeliveryRestaurantRecord.sampleRestaurants[0]
        return [
            DeliveryCartItemRecord(menuItemID: restaurant.menu[0].id, name: restaurant.menu[0].name, restaurant: restaurant.name, quantity: 2, unitPrice: restaurant.menu[0].price),
            DeliveryCartItemRecord(menuItemID: restaurant.menu[1].id, name: restaurant.menu[1].name, restaurant: restaurant.name, quantity: 1, unitPrice: restaurant.menu[1].price)
        ]
    }()
}

struct DeliveryOrderRecord: Identifiable {
    let id: UUID
    let restaurantName: String
    var status: String
    var eta: String
    var courierName: String
    var total: Double
    var progress: Double
    var timeline: [String]
    var supportStatus: String

    init(
        id: UUID = UUID(),
        restaurantName: String,
        status: String,
        eta: String,
        courierName: String,
        total: Double,
        progress: Double,
        timeline: [String],
        supportStatus: String
    ) {
        self.id = id
        self.restaurantName = restaurantName
        self.status = status
        self.eta = eta
        self.courierName = courierName
        self.total = total
        self.progress = progress
        self.timeline = timeline
        self.supportStatus = supportStatus
    }

    static let sampleLive = DeliveryOrderRecord(
        restaurantName: "Levant Kitchen",
        status: "Courier arriving",
        eta: "8 min",
        courierName: "Mert",
        total: 24.4,
        progress: 0.82,
        timeline: ["Order confirmed", "Kitchen preparing", "Courier picked up", "Courier arriving"],
        supportStatus: "Healthy"
    )

    static let samplePast: [DeliveryOrderRecord] = [
        sampleLive,
        DeliveryOrderRecord(restaurantName: "Daily Greens", status: "Delivered", eta: "Delivered Apr 24", courierName: "Aylin", total: 19.2, progress: 1.0, timeline: ["Order confirmed", "Delivered on time"], supportStatus: "Closed"),
        DeliveryOrderRecord(restaurantName: "Burger Works", status: "Delivered", eta: "Delivered Apr 21", courierName: "Can", total: 27.6, progress: 1.0, timeline: ["Order confirmed", "Delivered with photo"], supportStatus: "Closed")
    ]
}

private extension Double {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
