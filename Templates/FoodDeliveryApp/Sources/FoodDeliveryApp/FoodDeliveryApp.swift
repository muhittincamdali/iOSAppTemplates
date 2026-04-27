import SwiftUI
import FoodDeliveryAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct FoodDeliveryAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            FoodDeliveryWorkspaceRootView(
                snapshot: .sample,
                actions: FoodDeliveryQuickAction.defaultActions,
                state: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryWorkspaceRootView: View {
    let snapshot: FoodDeliveryDashboardSnapshot
    let actions: [FoodDeliveryQuickAction]
    let state: FoodDeliveryWorkspaceState

    var body: some View {
        TabView {
            FoodDeliveryDashboardView(snapshot: snapshot, actions: actions, state: state)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            FoodDeliveryRestaurantsView(state: state)
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Browse")
                }

            FoodDeliveryCartView(state: state)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }

            FoodDeliveryOrdersView(state: state)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Orders")
                }

            FoodDeliveryProfileView(state: state)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryDashboardView: View {
    let snapshot: FoodDeliveryDashboardSnapshot
    let actions: [FoodDeliveryQuickAction]
    let state: FoodDeliveryWorkspaceState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    FoodDeliveryHeroCard(snapshot: snapshot, state: state)
                    FoodDeliveryQuickActionGrid(actions: actions)
                    FoodDeliveryFeaturedRestaurantsView(restaurants: state.featuredRestaurants)
                    FoodDeliveryOrderStatusCard(order: state.liveOrder)
                    FoodDeliveryDealsCard(deals: state.activeDeals)
                }
                .padding(16)
            }
            .navigationTitle("Delivery")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryHeroCard: View {
    let snapshot: FoodDeliveryDashboardSnapshot
    let state: FoodDeliveryWorkspaceState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tonight's Plan")
                .font(.headline)
                .foregroundStyle(.secondary)

            Text(snapshot.liveOrderStatus)
                .font(.title2.weight(.bold))
            Text("Featured cuisine: \(snapshot.featuredCuisine). Reorder your favorites or finish checkout before the next courier wave.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                FoodDeliveryMetricChip(title: "Restaurants", value: "\(snapshot.restaurants)")
                FoodDeliveryMetricChip(title: "Average ETA", value: snapshot.averageETA)
                FoodDeliveryMetricChip(title: "Saved This Month", value: state.monthlySavings)
            }

            HStack {
                Label(state.deliveryAddress, systemImage: "location.fill")
                Spacer()
                Text(state.membershipTier)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.orange)
            }
            .font(.caption)
            .foregroundStyle(.secondary)
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

@available(iOS 18.0, macOS 15.0, *)
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

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryQuickActionGrid: View {
    let actions: [FoodDeliveryQuickAction]

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
struct FoodDeliveryFeaturedRestaurantsView: View {
    let restaurants: [FoodDeliveryRestaurant]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured Restaurants")
                .font(.title3.weight(.bold))

            ForEach(restaurants) { restaurant in
                NavigationLink {
                    FoodDeliveryRestaurantDetailView(restaurant: restaurant)
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
                            Label(restaurant.deliveryFee, systemImage: "scooter")
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

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryOrderStatusCard: View {
    let order: FoodDeliveryOrder

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Live Order")
                .font(.title3.weight(.bold))

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(order.restaurantName)
                        .font(.headline)
                    Text(order.status)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)
                    Text("Courier: \(order.courierName) • \(order.eta)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(order.total)
                    .font(.title3.weight(.bold))
            }

            ProgressView(value: order.progress)
                .tint(.orange)

            ForEach(order.timeline, id: \.self) { checkpoint in
                Label(checkpoint, systemImage: "checkmark.circle.fill")
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
struct FoodDeliveryDealsCard: View {
    let deals: [FoodDeliveryDeal]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Deals")
                .font(.title3.weight(.bold))

            ForEach(deals) { deal in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: deal.systemImage)
                        .foregroundStyle(deal.accent)
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(deal.title)
                            .font(.headline)
                        Text(deal.detail)
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

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryRestaurantsView: View {
    let state: FoodDeliveryWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Browse") {
                    ForEach(state.restaurants) { restaurant in
                        NavigationLink {
                            FoodDeliveryRestaurantDetailView(restaurant: restaurant)
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

                Section("Cuisines") {
                    ForEach(state.cuisines, id: \.self) { cuisine in
                        Label(cuisine, systemImage: "fork.knife.circle")
                    }
                }
            }
            .navigationTitle("Restaurants")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryCartView: View {
    let state: FoodDeliveryWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Cart Items") {
                    ForEach(state.cartItems) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(item.name)
                                Spacer()
                                Text(item.price)
                                    .font(.headline.weight(.bold))
                            }
                            Text("\(item.quantity)x • \(item.restaurant)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Checkout") {
                    LabeledContent("Subtotal", value: state.subtotal)
                    LabeledContent("Delivery Fee", value: state.deliveryFee)
                    LabeledContent("Service Fee", value: state.serviceFee)
                    LabeledContent("Promo", value: state.promoSavings)
                    LabeledContent("Total", value: state.cartTotal)
                        .font(.headline)
                }
            }
            .navigationTitle("Cart")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryOrdersView: View {
    let state: FoodDeliveryWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Live") {
                    NavigationLink {
                        FoodDeliveryOrderDetailView(order: state.liveOrder)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(state.liveOrder.restaurantName)
                            Text("\(state.liveOrder.status) • \(state.liveOrder.eta)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Past Orders") {
                    ForEach(state.pastOrders) { order in
                        NavigationLink {
                            FoodDeliveryOrderDetailView(order: order)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(order.restaurantName)
                                Text("\(order.status) • \(order.total)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryProfileView: View {
    let state: FoodDeliveryWorkspaceState

    var body: some View {
        NavigationStack {
            List {
                Section("Membership") {
                    LabeledContent("Tier", value: state.membershipTier)
                    LabeledContent("Delivery Address", value: state.deliveryAddress)
                    LabeledContent("Default Payment", value: state.defaultPaymentMethod)
                }

                Section("Habits") {
                    LabeledContent("Favorite Cuisine", value: state.favoriteCuisine)
                    LabeledContent("Monthly Savings", value: state.monthlySavings)
                    LabeledContent("Orders This Month", value: "\(state.ordersThisMonth)")
                }

                Section("Actions") {
                    ForEach(state.profileActions, id: \.self) { action in
                        Label(action, systemImage: "arrow.right.circle")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryRestaurantDetailView: View {
    let restaurant: FoodDeliveryRestaurant

    var body: some View {
        List {
            Section("Restaurant") {
                LabeledContent("Name", value: restaurant.name)
                LabeledContent("Cuisine", value: restaurant.cuisine)
                LabeledContent("Delivery Time", value: restaurant.deliveryTime)
                LabeledContent("Delivery Fee", value: restaurant.deliveryFee)
                LabeledContent("Best Seller", value: restaurant.bestSeller)
            }

            Section("Menu Highlights") {
                ForEach(restaurant.menuHighlights, id: \.self) { item in
                    Label(item, systemImage: "takeoutbag.and.cup.and.straw.fill")
                }
            }
        }
        .navigationTitle(restaurant.name)
    }
}

@available(iOS 18.0, macOS 15.0, *)
struct FoodDeliveryOrderDetailView: View {
    let order: FoodDeliveryOrder

    var body: some View {
        List {
            Section("Order") {
                LabeledContent("Restaurant", value: order.restaurantName)
                LabeledContent("Status", value: order.status)
                LabeledContent("ETA", value: order.eta)
                LabeledContent("Courier", value: order.courierName)
                LabeledContent("Total", value: order.total)
            }

            Section("Timeline") {
                ForEach(order.timeline, id: \.self) { step in
                    Label(step, systemImage: "clock.arrow.circlepath")
                }
            }
        }
        .navigationTitle("Order")
    }
}

public struct FoodDeliveryQuickAction: Identifiable, Hashable, Sendable {
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

    public static let defaultActions: [FoodDeliveryQuickAction] = [
        FoodDeliveryQuickAction(title: "Browse Restaurants", detail: "Jump into the highest-rated places that can still deliver before the next hour.", systemImage: "fork.knife.circle.fill"),
        FoodDeliveryQuickAction(title: "Open Cart", detail: "Review line items, fees, and promo savings before checkout.", systemImage: "cart.fill"),
        FoodDeliveryQuickAction(title: "Track Order", detail: "Check courier progress and resolve delivery issues before arrival.", systemImage: "location.fill"),
        FoodDeliveryQuickAction(title: "Reorder Favorites", detail: "Repeat the last high-rated meal flow with one tap.", systemImage: "arrow.clockwise.circle.fill")
    ]
}

struct FoodDeliveryWorkspaceState: Hashable, Sendable {
    let membershipTier: String
    let deliveryAddress: String
    let defaultPaymentMethod: String
    let favoriteCuisine: String
    let monthlySavings: String
    let ordersThisMonth: Int
    let subtotal: String
    let deliveryFee: String
    let serviceFee: String
    let promoSavings: String
    let cartTotal: String
    let featuredRestaurants: [FoodDeliveryRestaurant]
    let restaurants: [FoodDeliveryRestaurant]
    let activeDeals: [FoodDeliveryDeal]
    let liveOrder: FoodDeliveryOrder
    let pastOrders: [FoodDeliveryOrder]
    let cartItems: [FoodDeliveryCartItem]
    let cuisines: [String]
    let profileActions: [String]

    static let sample = FoodDeliveryWorkspaceState(
        membershipTier: "Plus",
        deliveryAddress: "Moda, Kadikoy",
        defaultPaymentMethod: "Visa •••• 4021",
        favoriteCuisine: "Mediterranean",
        monthlySavings: "$48",
        ordersThisMonth: 11,
        subtotal: "$38.90",
        deliveryFee: "$2.99",
        serviceFee: "$1.80",
        promoSavings: "-$6.00",
        cartTotal: "$37.69",
        featuredRestaurants: [
            FoodDeliveryRestaurant(name: "Levant Kitchen", cuisine: "Mediterranean", distance: "1.2 km", deliveryTime: "18-24 min", deliveryFee: "$1.99", rating: "4.8", bestSeller: "Chicken Shawarma Bowl", menuHighlights: ["Chicken Shawarma Bowl", "Hummus Trio", "Pita Fries"]),
            FoodDeliveryRestaurant(name: "Zen Ramen Club", cuisine: "Japanese", distance: "2.4 km", deliveryTime: "22-30 min", deliveryFee: "$2.49", rating: "4.7", bestSeller: "Spicy Tonkotsu", menuHighlights: ["Spicy Tonkotsu", "Gyoza", "Miso Eggplant"]),
            FoodDeliveryRestaurant(name: "Daily Greens", cuisine: "Healthy", distance: "0.9 km", deliveryTime: "16-22 min", deliveryFee: "$0.99", rating: "4.9", bestSeller: "Salmon Power Bowl", menuHighlights: ["Salmon Power Bowl", "Berry Protein Shake", "Avocado Crunch Salad"])
        ],
        restaurants: [
            FoodDeliveryRestaurant(name: "Levant Kitchen", cuisine: "Mediterranean", distance: "1.2 km", deliveryTime: "18-24 min", deliveryFee: "$1.99", rating: "4.8", bestSeller: "Chicken Shawarma Bowl", menuHighlights: ["Chicken Shawarma Bowl", "Hummus Trio", "Pita Fries"]),
            FoodDeliveryRestaurant(name: "Zen Ramen Club", cuisine: "Japanese", distance: "2.4 km", deliveryTime: "22-30 min", deliveryFee: "$2.49", rating: "4.7", bestSeller: "Spicy Tonkotsu", menuHighlights: ["Spicy Tonkotsu", "Gyoza", "Miso Eggplant"]),
            FoodDeliveryRestaurant(name: "Daily Greens", cuisine: "Healthy", distance: "0.9 km", deliveryTime: "16-22 min", deliveryFee: "$0.99", rating: "4.9", bestSeller: "Salmon Power Bowl", menuHighlights: ["Salmon Power Bowl", "Berry Protein Shake", "Avocado Crunch Salad"]),
            FoodDeliveryRestaurant(name: "Burger Works", cuisine: "American", distance: "1.8 km", deliveryTime: "20-28 min", deliveryFee: "$1.49", rating: "4.6", bestSeller: "Double Smash Burger", menuHighlights: ["Double Smash Burger", "Loaded Fries", "Strawberry Shake"])
        ],
        activeDeals: [
            FoodDeliveryDeal(title: "Free delivery after 19:00", detail: "Use the evening window to remove delivery fees from selected partners.", systemImage: "scooter", accent: .orange),
            FoodDeliveryDeal(title: "20% off healthy picks", detail: "Plus members keep the discount on bowls and salads until Friday.", systemImage: "leaf.fill", accent: .green),
            FoodDeliveryDeal(title: "Reorder streak bonus", detail: "Complete one more order this week to unlock a $5 loyalty credit.", systemImage: "gift.fill", accent: .pink)
        ],
        liveOrder: FoodDeliveryOrder(restaurantName: "Levant Kitchen", status: "Courier arriving", eta: "8 min", courierName: "Mert", total: "$24.40", progress: 0.82, timeline: ["Order confirmed", "Kitchen preparing", "Courier picked up", "Courier arriving"]),
        pastOrders: [
            FoodDeliveryOrder(restaurantName: "Daily Greens", status: "Delivered", eta: "Delivered Apr 24", courierName: "Aylin", total: "$19.20", progress: 1.0, timeline: ["Order confirmed", "Delivered on time"]),
            FoodDeliveryOrder(restaurantName: "Burger Works", status: "Delivered", eta: "Delivered Apr 21", courierName: "Can", total: "$27.60", progress: 1.0, timeline: ["Order confirmed", "Delivered with photo"])
        ],
        cartItems: [
            FoodDeliveryCartItem(name: "Chicken Shawarma Bowl", restaurant: "Levant Kitchen", quantity: 2, price: "$16.80"),
            FoodDeliveryCartItem(name: "Hummus Trio", restaurant: "Levant Kitchen", quantity: 1, price: "$8.10"),
            FoodDeliveryCartItem(name: "Pita Fries", restaurant: "Levant Kitchen", quantity: 1, price: "$5.00")
        ],
        cuisines: ["Mediterranean", "Japanese", "Healthy", "Burgers", "Desserts"],
        profileActions: [
            "Update delivery instructions for the evening concierge window.",
            "Review loyalty credit usage before the next checkout.",
            "Manage saved payment methods and reorder preferences."
        ]
    )
}

struct FoodDeliveryRestaurant: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let cuisine: String
    let distance: String
    let deliveryTime: String
    let deliveryFee: String
    let rating: String
    let bestSeller: String
    let menuHighlights: [String]
}

struct FoodDeliveryDeal: Identifiable, Hashable, Sendable {
    let id = UUID()
    let title: String
    let detail: String
    let systemImage: String
    let accent: Color
}

struct FoodDeliveryOrder: Identifiable, Hashable, Sendable {
    let id = UUID()
    let restaurantName: String
    let status: String
    let eta: String
    let courierName: String
    let total: String
    let progress: Double
    let timeline: [String]
}

struct FoodDeliveryCartItem: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let restaurant: String
    let quantity: Int
    let price: String
}
