// MARK: - Food Delivery Template
// Complete food delivery app with 14+ screens
// Features: Restaurants, Menu, Cart, Orders, Tracking, Reviews
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine
import CoreLocation

// MARK: - Models

public struct Restaurant: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let description: String
    public let cuisine: [CuisineType]
    public let rating: Double
    public let reviewCount: Int
    public let priceLevel: PriceLevel
    public let deliveryTime: ClosedRange<Int>
    public let deliveryFee: Decimal
    public let minimumOrder: Decimal
    public let distance: Double
    public let imageURL: String?
    public let isOpen: Bool
    public let isFeatured: Bool
    public let hasPromo: Bool
    public let promoText: String?
    public let address: String
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        cuisine: [CuisineType] = [],
        rating: Double = 4.5,
        reviewCount: Int = 100,
        priceLevel: PriceLevel = .medium,
        deliveryTime: ClosedRange<Int> = 20...35,
        deliveryFee: Decimal = 2.99,
        minimumOrder: Decimal = 10,
        distance: Double = 1.5,
        imageURL: String? = nil,
        isOpen: Bool = true,
        isFeatured: Bool = false,
        hasPromo: Bool = false,
        promoText: String? = nil,
        address: String = ""
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.cuisine = cuisine
        self.rating = rating
        self.reviewCount = reviewCount
        self.priceLevel = priceLevel
        self.deliveryTime = deliveryTime
        self.deliveryFee = deliveryFee
        self.minimumOrder = minimumOrder
        self.distance = distance
        self.imageURL = imageURL
        self.isOpen = isOpen
        self.isFeatured = isFeatured
        self.hasPromo = hasPromo
        self.promoText = promoText
        self.address = address
    }
}

public enum CuisineType: String, Codable, CaseIterable {
    case american = "American"
    case italian = "Italian"
    case chinese = "Chinese"
    case japanese = "Japanese"
    case mexican = "Mexican"
    case indian = "Indian"
    case thai = "Thai"
    case mediterranean = "Mediterranean"
    case fastFood = "Fast Food"
    case pizza = "Pizza"
    case burger = "Burger"
    case sushi = "Sushi"
    case healthy = "Healthy"
    case dessert = "Dessert"
    case coffee = "Coffee"
    
    public var icon: String {
        switch self {
        case .american: return "🍔"
        case .italian: return "🍝"
        case .chinese: return "🥡"
        case .japanese: return "🍱"
        case .mexican: return "🌮"
        case .indian: return "🍛"
        case .thai: return "🍜"
        case .mediterranean: return "🥙"
        case .fastFood: return "🍟"
        case .pizza: return "🍕"
        case .burger: return "🍔"
        case .sushi: return "🍣"
        case .healthy: return "🥗"
        case .dessert: return "🍰"
        case .coffee: return "☕"
        }
    }
}

public enum PriceLevel: Int, Codable, CaseIterable {
    case budget = 1
    case medium = 2
    case expensive = 3
    case premium = 4
    
    public var symbol: String {
        String(repeating: "$", count: rawValue)
    }
}

public struct MenuItem: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let description: String
    public let price: Decimal
    public let imageURL: String?
    public let category: MenuCategory
    public let calories: Int?
    public let isPopular: Bool
    public let isVegetarian: Bool
    public let isVegan: Bool
    public let isGlutenFree: Bool
    public let spicyLevel: Int
    public let customizations: [Customization]
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        price: Decimal,
        imageURL: String? = nil,
        category: MenuCategory = .mains,
        calories: Int? = nil,
        isPopular: Bool = false,
        isVegetarian: Bool = false,
        isVegan: Bool = false,
        isGlutenFree: Bool = false,
        spicyLevel: Int = 0,
        customizations: [Customization] = []
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = imageURL
        self.category = category
        self.calories = calories
        self.isPopular = isPopular
        self.isVegetarian = isVegetarian
        self.isVegan = isVegan
        self.isGlutenFree = isGlutenFree
        self.spicyLevel = spicyLevel
        self.customizations = customizations
    }
}

public enum MenuCategory: String, Codable, CaseIterable {
    case popular = "Popular"
    case appetizers = "Appetizers"
    case mains = "Main Courses"
    case sides = "Sides"
    case drinks = "Drinks"
    case desserts = "Desserts"
}

public struct Customization: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let options: [CustomizationOption]
    public let isRequired: Bool
    public let maxSelections: Int
    
    public init(
        id: UUID = UUID(),
        name: String,
        options: [CustomizationOption],
        isRequired: Bool = false,
        maxSelections: Int = 1
    ) {
        self.id = id
        self.name = name
        self.options = options
        self.isRequired = isRequired
        self.maxSelections = maxSelections
    }
}

public struct CustomizationOption: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let price: Decimal
    
    public init(id: UUID = UUID(), name: String, price: Decimal = 0) {
        self.id = id
        self.name = name
        self.price = price
    }
}

public struct CartItem: Identifiable, Codable {
    public let id: UUID
    public let menuItem: MenuItem
    public var quantity: Int
    public var selectedCustomizations: [String: [String]]
    public var specialInstructions: String?
    
    public init(
        id: UUID = UUID(),
        menuItem: MenuItem,
        quantity: Int = 1,
        selectedCustomizations: [String: [String]] = [:],
        specialInstructions: String? = nil
    ) {
        self.id = id
        self.menuItem = menuItem
        self.quantity = quantity
        self.selectedCustomizations = selectedCustomizations
        self.specialInstructions = specialInstructions
    }
    
    public var totalPrice: Decimal {
        menuItem.price * Decimal(quantity)
    }
}

public struct FoodOrder: Identifiable, Codable {
    public let id: UUID
    public let restaurant: Restaurant
    public let items: [CartItem]
    public let subtotal: Decimal
    public let deliveryFee: Decimal
    public let serviceFee: Decimal
    public let tip: Decimal
    public let total: Decimal
    public let deliveryAddress: DeliveryAddress
    public let paymentMethod: String
    public var status: OrderStatus
    public let createdAt: Date
    public var estimatedDelivery: Date
    public var driverName: String?
    public var driverPhone: String?
    
    public init(
        id: UUID = UUID(),
        restaurant: Restaurant,
        items: [CartItem],
        subtotal: Decimal,
        deliveryFee: Decimal,
        serviceFee: Decimal = 1.99,
        tip: Decimal = 0,
        total: Decimal,
        deliveryAddress: DeliveryAddress,
        paymentMethod: String = "Credit Card",
        status: OrderStatus = .placed,
        createdAt: Date = Date(),
        estimatedDelivery: Date = Date().addingTimeInterval(2400),
        driverName: String? = nil,
        driverPhone: String? = nil
    ) {
        self.id = id
        self.restaurant = restaurant
        self.items = items
        self.subtotal = subtotal
        self.deliveryFee = deliveryFee
        self.serviceFee = serviceFee
        self.tip = tip
        self.total = total
        self.deliveryAddress = deliveryAddress
        self.paymentMethod = paymentMethod
        self.status = status
        self.createdAt = createdAt
        self.estimatedDelivery = estimatedDelivery
        self.driverName = driverName
        self.driverPhone = driverPhone
    }
}

public enum OrderStatus: String, Codable, CaseIterable {
    case placed = "Order Placed"
    case confirmed = "Confirmed"
    case preparing = "Preparing"
    case readyForPickup = "Ready for Pickup"
    case pickedUp = "Picked Up"
    case onTheWay = "On the Way"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    public var icon: String {
        switch self {
        case .placed: return "checkmark.circle"
        case .confirmed: return "hand.thumbsup"
        case .preparing: return "frying.pan"
        case .readyForPickup: return "bag"
        case .pickedUp: return "bicycle"
        case .onTheWay: return "car"
        case .delivered: return "checkmark.seal"
        case .cancelled: return "xmark.circle"
        }
    }
    
    public var color: Color {
        switch self {
        case .placed, .confirmed: return .blue
        case .preparing: return .orange
        case .readyForPickup, .pickedUp: return .purple
        case .onTheWay: return .cyan
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}

public struct DeliveryAddress: Identifiable, Codable {
    public let id: UUID
    public var label: String
    public var street: String
    public var apartment: String?
    public var city: String
    public var zipCode: String
    public var instructions: String?
    public var isDefault: Bool
    
    public init(
        id: UUID = UUID(),
        label: String = "Home",
        street: String = "",
        apartment: String? = nil,
        city: String = "",
        zipCode: String = "",
        instructions: String? = nil,
        isDefault: Bool = false
    ) {
        self.id = id
        self.label = label
        self.street = street
        self.apartment = apartment
        self.city = city
        self.zipCode = zipCode
        self.instructions = instructions
        self.isDefault = isDefault
    }
    
    public var fullAddress: String {
        var address = street
        if let apt = apartment, !apt.isEmpty {
            address += ", \(apt)"
        }
        address += ", \(city) \(zipCode)"
        return address
    }
}

public struct RestaurantReview: Identifiable, Codable {
    public let id: UUID
    public let userName: String
    public let rating: Int
    public let comment: String
    public let date: Date
    public let orderItems: [String]
    public let helpful: Int
    
    public init(
        id: UUID = UUID(),
        userName: String,
        rating: Int,
        comment: String,
        date: Date = Date(),
        orderItems: [String] = [],
        helpful: Int = 0
    ) {
        self.id = id
        self.userName = userName
        self.rating = rating
        self.comment = comment
        self.date = date
        self.orderItems = orderItems
        self.helpful = helpful
    }
}

// MARK: - Sample Data

public enum FoodSampleData {
    public static let restaurants: [Restaurant] = [
        Restaurant(
            name: "Burger Palace",
            description: "Gourmet burgers made with 100% Angus beef",
            cuisine: [.burger, .american, .fastFood],
            rating: 4.7,
            reviewCount: 2340,
            priceLevel: .medium,
            deliveryTime: 20...35,
            deliveryFee: 2.99,
            distance: 1.2,
            isFeatured: true,
            hasPromo: true,
            promoText: "20% off first order",
            address: "123 Main St"
        ),
        Restaurant(
            name: "Pizza Napoli",
            description: "Authentic Italian pizza, baked in wood-fired oven",
            cuisine: [.pizza, .italian],
            rating: 4.8,
            reviewCount: 1890,
            priceLevel: .medium,
            deliveryTime: 25...40,
            deliveryFee: 1.99,
            distance: 0.8,
            isFeatured: true,
            address: "456 Oak Ave"
        ),
        Restaurant(
            name: "Sakura Sushi",
            description: "Fresh sushi and Japanese cuisine",
            cuisine: [.sushi, .japanese],
            rating: 4.9,
            reviewCount: 3210,
            priceLevel: .expensive,
            deliveryTime: 30...45,
            deliveryFee: 3.99,
            distance: 2.1,
            address: "789 Cherry Ln"
        ),
        Restaurant(
            name: "Taco Fiesta",
            description: "Authentic Mexican street food",
            cuisine: [.mexican],
            rating: 4.5,
            reviewCount: 1567,
            priceLevel: .budget,
            deliveryTime: 15...25,
            deliveryFee: 1.49,
            distance: 0.5,
            hasPromo: true,
            promoText: "Free delivery",
            address: "321 Elm St"
        ),
        Restaurant(
            name: "Dragon Palace",
            description: "Traditional Chinese cuisine",
            cuisine: [.chinese],
            rating: 4.4,
            reviewCount: 2100,
            priceLevel: .medium,
            deliveryTime: 25...40,
            deliveryFee: 2.49,
            distance: 1.8,
            address: "654 Pine Rd"
        ),
        Restaurant(
            name: "Green Bowl",
            description: "Healthy salads and grain bowls",
            cuisine: [.healthy],
            rating: 4.6,
            reviewCount: 980,
            priceLevel: .medium,
            deliveryTime: 15...25,
            deliveryFee: 1.99,
            distance: 1.0,
            address: "987 Maple Dr"
        )
    ]
    
    public static let menuItems: [MenuItem] = [
        MenuItem(name: "Classic Cheeseburger", description: "Angus beef patty with American cheese, lettuce, tomato, and special sauce", price: 12.99, category: .popular, calories: 850, isPopular: true),
        MenuItem(name: "Double Bacon Burger", description: "Two beef patties with crispy bacon and cheddar cheese", price: 16.99, category: .mains, calories: 1200, isPopular: true),
        MenuItem(name: "Veggie Burger", description: "Plant-based patty with avocado and chipotle mayo", price: 13.99, category: .mains, calories: 650, isVegetarian: true, isVegan: true),
        MenuItem(name: "Crispy Fries", description: "Golden, crispy fries with sea salt", price: 4.99, category: .sides, calories: 380),
        MenuItem(name: "Onion Rings", description: "Beer-battered onion rings", price: 5.99, category: .sides, calories: 420),
        MenuItem(name: "Chicken Wings", description: "Crispy wings with your choice of sauce", price: 11.99, category: .appetizers, calories: 680, spicyLevel: 2),
        MenuItem(name: "Milkshake", description: "Creamy milkshake in vanilla, chocolate, or strawberry", price: 6.99, category: .drinks, calories: 550),
        MenuItem(name: "Soft Drink", description: "Coca-Cola, Sprite, or Fanta", price: 2.99, category: .drinks, calories: 150),
        MenuItem(name: "Chocolate Brownie", description: "Warm chocolate brownie with vanilla ice cream", price: 7.99, category: .desserts, calories: 650)
    ]
    
    public static let defaultAddress = DeliveryAddress(
        label: "Home",
        street: "123 Main Street",
        apartment: "Apt 4B",
        city: "San Francisco",
        zipCode: "94102",
        isDefault: true
    )
    
    public static let reviews: [RestaurantReview] = [
        RestaurantReview(userName: "Mike S.", rating: 5, comment: "Best burgers in town! Always fresh and delivered hot.", orderItems: ["Classic Cheeseburger", "Fries"], helpful: 45),
        RestaurantReview(userName: "Sarah L.", rating: 4, comment: "Great food, delivery was a bit slow but worth the wait.", orderItems: ["Double Bacon Burger"], helpful: 23),
        RestaurantReview(userName: "John D.", rating: 5, comment: "The veggie burger is amazing! Will order again.", orderItems: ["Veggie Burger", "Onion Rings"], helpful: 18)
    ]
}

// MARK: - View Models

@MainActor
public class FoodStore: ObservableObject {
    @Published public var restaurants: [Restaurant] = FoodSampleData.restaurants
    @Published public var cart: [CartItem] = []
    @Published public var currentRestaurant: Restaurant?
    @Published public var orders: [FoodOrder] = []
    @Published public var addresses: [DeliveryAddress] = [FoodSampleData.defaultAddress]
    @Published public var selectedAddress: DeliveryAddress?
    @Published public var searchQuery: String = ""
    @Published public var selectedCuisine: CuisineType?
    @Published public var favoriteRestaurants: Set<UUID> = []
    @Published public var activeOrder: FoodOrder?
    
    public init() {
        selectedAddress = addresses.first
    }
    
    public var filteredRestaurants: [Restaurant] {
        var result = restaurants
        
        if !searchQuery.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery) ||
                $0.cuisine.contains { $0.rawValue.localizedCaseInsensitiveContains(searchQuery) }
            }
        }
        
        if let cuisine = selectedCuisine {
            result = result.filter { $0.cuisine.contains(cuisine) }
        }
        
        return result
    }
    
    public var cartTotal: Decimal {
        cart.reduce(0) { $0 + $1.totalPrice }
    }
    
    public var cartItemCount: Int {
        cart.reduce(0) { $0 + $1.quantity }
    }
    
    public func addToCart(_ item: MenuItem) {
        if let index = cart.firstIndex(where: { $0.menuItem.id == item.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartItem(menuItem: item))
        }
    }
    
    public func removeFromCart(_ item: CartItem) {
        cart.removeAll { $0.id == item.id }
    }
    
    public func updateQuantity(_ item: CartItem, quantity: Int) {
        if let index = cart.firstIndex(where: { $0.id == item.id }) {
            if quantity <= 0 {
                cart.remove(at: index)
            } else {
                cart[index].quantity = quantity
            }
        }
    }
    
    public func clearCart() {
        cart.removeAll()
        currentRestaurant = nil
    }
    
    public func toggleFavorite(_ restaurantId: UUID) {
        if favoriteRestaurants.contains(restaurantId) {
            favoriteRestaurants.remove(restaurantId)
        } else {
            favoriteRestaurants.insert(restaurantId)
        }
    }
    
    public func placeOrder(tip: Decimal) -> FoodOrder? {
        guard let restaurant = currentRestaurant, let address = selectedAddress else { return nil }
        
        let serviceFee: Decimal = 1.99
        let total = cartTotal + restaurant.deliveryFee + serviceFee + tip
        
        let order = FoodOrder(
            restaurant: restaurant,
            items: cart,
            subtotal: cartTotal,
            deliveryFee: restaurant.deliveryFee,
            serviceFee: serviceFee,
            tip: tip,
            total: total,
            deliveryAddress: address
        )
        
        orders.insert(order, at: 0)
        activeOrder = order
        clearCart()
        
        return order
    }
}

// MARK: - Views

// 1. Main Food Home View
public struct FoodDeliveryHomeView: View {
    @StateObject private var store = FoodStore()
    @State private var selectedTab = 0
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            FoodHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            SearchFoodView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            OrdersHistoryView()
                .tabItem {
                    Label("Orders", systemImage: "bag")
                }
                .tag(2)
            
            FoodProfileView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(3)
        }
        .environmentObject(store)
    }
}

// 2. Food Home View
public struct FoodHomeView: View {
    @EnvironmentObject var store: FoodStore
    @State private var showingCart = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Delivery Address
                    DeliveryAddressHeader()
                    
                    // Search Bar
                    SearchBarFood()
                    
                    // Categories
                    CuisineScrollView()
                    
                    // Active Order
                    if let activeOrder = store.activeOrder {
                        ActiveOrderBanner(order: activeOrder)
                    }
                    
                    // Promotions
                    PromotionsBanner()
                    
                    // Featured Restaurants
                    FeaturedRestaurantsSection()
                    
                    // All Restaurants
                    AllRestaurantsSection()
                }
                .padding(.vertical)
            }
            .navigationTitle("Food Delivery")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingCart = true
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart")
                                .font(.title3)
                            
                            if store.cartItemCount > 0 {
                                Text("\(store.cartItemCount)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .padding(4)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCart) {
                CartViewFood()
                    .environmentObject(store)
            }
        }
    }
}

// 3. Delivery Address Header
struct DeliveryAddressHeader: View {
    @EnvironmentObject var store: FoodStore
    
    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Deliver to")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(store.selectedAddress?.label ?? "Add Address")
                    .fontWeight(.semibold)
            }
            
            Image(systemName: "chevron.down")
                .font(.caption)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// 4. Search Bar
struct SearchBarFood: View {
    @EnvironmentObject var store: FoodStore
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search restaurants, cuisines...", text: $store.searchQuery)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

// 5. Cuisine Scroll View
struct CuisineScrollView: View {
    @EnvironmentObject var store: FoodStore
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(CuisineType.allCases, id: \.self) { cuisine in
                    Button {
                        if store.selectedCuisine == cuisine {
                            store.selectedCuisine = nil
                        } else {
                            store.selectedCuisine = cuisine
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Text(cuisine.icon)
                                .font(.title)
                                .frame(width: 50, height: 50)
                                .background(store.selectedCuisine == cuisine ? Color.orange.opacity(0.2) : Color(.systemGray6))
                                .clipShape(Circle())
                            
                            Text(cuisine.rawValue)
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// 6. Active Order Banner
struct ActiveOrderBanner: View {
    let order: FoodOrder
    
    var body: some View {
        NavigationLink {
            OrderTrackingView(order: order)
        } label: {
            HStack {
                Image(systemName: order.status.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(order.status.color)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.status.rawValue)
                        .fontWeight(.semibold)
                    
                    Text(order.restaurant.name)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("Track Order")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}

// 7. Promotions Banner
struct PromotionsBanner: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                PromoBannerCard(
                    title: "Free Delivery",
                    subtitle: "On orders over $20",
                    gradient: [.orange, .red]
                )
                
                PromoBannerCard(
                    title: "20% Off",
                    subtitle: "First order discount",
                    gradient: [.purple, .pink]
                )
                
                PromoBannerCard(
                    title: "$5 Off",
                    subtitle: "Use code: SAVE5",
                    gradient: [.blue, .cyan]
                )
            }
            .padding(.horizontal)
        }
    }
}

struct PromoBannerCard: View {
    let title: String
    let subtitle: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.caption)
                .opacity(0.9)
        }
        .foregroundColor(.white)
        .frame(width: 160, height: 100)
        .padding()
        .background(
            LinearGradient(colors: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(16)
    }
}

// 8. Featured Restaurants Section
struct FeaturedRestaurantsSection: View {
    @EnvironmentObject var store: FoodStore
    
    var featured: [Restaurant] {
        store.restaurants.filter { $0.isFeatured }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Featured")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(featured) { restaurant in
                        NavigationLink {
                            RestaurantDetailView(restaurant: restaurant)
                                .environmentObject(store)
                        } label: {
                            FeaturedRestaurantCard(restaurant: restaurant)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FeaturedRestaurantCard: View {
    @EnvironmentObject var store: FoodStore
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 200, height: 120)
                    .cornerRadius(12)
                    .overlay(
                        Text(restaurant.cuisine.first?.icon ?? "🍽️")
                            .font(.system(size: 40))
                    )
                
                if restaurant.hasPromo {
                    Text(restaurant.promoText ?? "Promo")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(restaurant.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    
                    Text(String(format: "%.1f", restaurant.rating))
                    Text("(\(restaurant.reviewCount))")
                        .foregroundColor(.secondary)
                    
                    Text("•")
                    Text(restaurant.priceLevel.symbol)
                        .foregroundColor(.secondary)
                }
                .font(.caption)
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(restaurant.deliveryTime.lowerBound)-\(restaurant.deliveryTime.upperBound) min")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .frame(width: 200)
    }
}

// 9. All Restaurants Section
struct AllRestaurantsSection: View {
    @EnvironmentObject var store: FoodStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Restaurants")
                .font(.headline)
                .padding(.horizontal)
            
            LazyVStack(spacing: 16) {
                ForEach(store.filteredRestaurants) { restaurant in
                    NavigationLink {
                        RestaurantDetailView(restaurant: restaurant)
                            .environmentObject(store)
                    } label: {
                        RestaurantRowCard(restaurant: restaurant)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RestaurantRowCard: View {
    @EnvironmentObject var store: FoodStore
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 100, height: 100)
                .cornerRadius(12)
                .overlay(
                    Text(restaurant.cuisine.first?.icon ?? "🍽️")
                        .font(.largeTitle)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(restaurant.name)
                    .font(.headline)
                
                Text(restaurant.cuisine.map { $0.rawValue }.joined(separator: " • "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", restaurant.rating))
                    }
                    
                    Text("•")
                    Text(restaurant.priceLevel.symbol)
                    
                    Text("•")
                    Text("\(restaurant.deliveryTime.lowerBound)-\(restaurant.deliveryTime.upperBound) min")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                if restaurant.deliveryFee > 0 {
                    Text("Delivery: \(restaurant.deliveryFee, format: .currency(code: "USD"))")
                        .font(.caption)
                        .foregroundColor(.green)
                } else {
                    Text("Free Delivery")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Button {
                store.toggleFavorite(restaurant.id)
            } label: {
                Image(systemName: store.favoriteRestaurants.contains(restaurant.id) ? "heart.fill" : "heart")
                    .foregroundColor(store.favoriteRestaurants.contains(restaurant.id) ? .red : .secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// 10. Restaurant Detail View
public struct RestaurantDetailView: View {
    @EnvironmentObject var store: FoodStore
    @Environment(\.dismiss) private var dismiss
    let restaurant: Restaurant
    @State private var selectedCategory: MenuCategory = .popular
    @State private var showingCart = false
    
    public init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Image
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 200)
                        .overlay(
                            Text(restaurant.cuisine.first?.icon ?? "🍽️")
                                .font(.system(size: 80))
                        )
                    
                    LinearGradient(colors: [.clear, .black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(restaurant.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(restaurant.cuisine.map { $0.rawValue }.joined(separator: " • "))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding()
                }
                
                // Info Section
                VStack(spacing: 16) {
                    HStack(spacing: 24) {
                        InfoBadge(icon: "star.fill", value: String(format: "%.1f", restaurant.rating), label: "Rating", color: .yellow)
                        InfoBadge(icon: "clock", value: "\(restaurant.deliveryTime.lowerBound)-\(restaurant.deliveryTime.upperBound)", label: "Minutes", color: .blue)
                        InfoBadge(icon: "bicycle", value: restaurant.deliveryFee == 0 ? "Free" : "\(restaurant.deliveryFee, format: .currency(code: "USD"))", label: "Delivery", color: .green)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Category Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(MenuCategory.allCases, id: \.self) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    Text(category.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(selectedCategory == category ? .semibold : .regular)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedCategory == category ? Color.orange : Color(.systemGray6))
                                        .foregroundColor(selectedCategory == category ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    
                    // Menu Items
                    LazyVStack(spacing: 12) {
                        ForEach(FoodSampleData.menuItems.filter { $0.category == selectedCategory }) { item in
                            MenuItemRow(item: item, restaurant: restaurant)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            if store.cartItemCount > 0 && store.currentRestaurant?.id == restaurant.id {
                Button {
                    showingCart = true
                } label: {
                    HStack {
                        Text("\(store.cartItemCount) items")
                        Spacer()
                        Text("View Cart")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(store.cartTotal, format: .currency(code: "USD"))
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
                .background(.bar)
            }
        }
        .sheet(isPresented: $showingCart) {
            CartViewFood()
                .environmentObject(store)
        }
    }
}

struct InfoBadge: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct MenuItemRow: View {
    @EnvironmentObject var store: FoodStore
    let item: MenuItem
    let restaurant: Restaurant
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(item.name)
                        .fontWeight(.semibold)
                    
                    if item.isPopular {
                        Text("Popular")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.orange)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text(item.price, format: .currency(code: "USD"))
                        .fontWeight(.medium)
                    
                    if let calories = item.calories {
                        Text("•")
                        Text("\(calories) cal")
                    }
                    
                    if item.isVegetarian {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                    }
                }
                .font(.caption)
            }
            
            Spacer()
            
            ZStack(alignment: .bottomTrailing) {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                
                Button {
                    if store.currentRestaurant == nil || store.currentRestaurant?.id == restaurant.id {
                        store.currentRestaurant = restaurant
                        store.addToCart(item)
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .background(Circle().fill(.white))
                }
                .offset(x: 8, y: 8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 11. Cart View
public struct CartViewFood: View {
    @EnvironmentObject var store: FoodStore
    @Environment(\.dismiss) private var dismiss
    @State private var showingCheckout = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Group {
                if store.cart.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("Your cart is empty")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Add items from a restaurant to get started")
                            .foregroundColor(.secondary)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            // Restaurant Info
                            if let restaurant = store.currentRestaurant {
                                HStack {
                                    Text(restaurant.name)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Button("Clear") {
                                        store.clearCart()
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            
                            // Cart Items
                            ForEach(store.cart) { item in
                                CartItemRowFood(item: item)
                            }
                            
                            // Add More Items
                            Button {
                                dismiss()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("Add more items")
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                            .foregroundColor(.primary)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !store.cart.isEmpty, let restaurant = store.currentRestaurant {
                    VStack(spacing: 12) {
                        Divider()
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text(store.cartTotal, format: .currency(code: "USD"))
                            }
                            
                            HStack {
                                Text("Delivery Fee")
                                Spacer()
                                Text(restaurant.deliveryFee, format: .currency(code: "USD"))
                            }
                            
                            HStack {
                                Text("Service Fee")
                                Spacer()
                                Text(1.99, format: .currency(code: "USD"))
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        
                        Divider()
                        
                        HStack {
                            Text("Total")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(store.cartTotal + restaurant.deliveryFee + 1.99, format: .currency(code: "USD"))
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        
                        Button {
                            showingCheckout = true
                        } label: {
                            Text("Proceed to Checkout")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(.bar)
                }
            }
            .sheet(isPresented: $showingCheckout) {
                CheckoutViewFood()
                    .environmentObject(store)
            }
        }
    }
}

struct CartItemRowFood: View {
    @EnvironmentObject var store: FoodStore
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.menuItem.name)
                    .fontWeight(.medium)
                
                Text(item.menuItem.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    store.updateQuantity(item, quantity: item.quantity - 1)
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.title3)
                }
                
                Text("\(item.quantity)")
                    .fontWeight(.semibold)
                
                Button {
                    store.updateQuantity(item, quantity: item.quantity + 1)
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 12. Checkout View
struct CheckoutViewFood: View {
    @EnvironmentObject var store: FoodStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTip: Int = 15
    @State private var showingOrderConfirmation = false
    @State private var placedOrder: FoodOrder?
    
    let tipOptions = [10, 15, 20, 25]
    
    var tipAmount: Decimal {
        Decimal(selectedTip) / 100 * store.cartTotal
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Delivery Address
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Delivery Address")
                            .font(.headline)
                        
                        if let address = store.selectedAddress {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading) {
                                    Text(address.label)
                                        .fontWeight(.medium)
                                    Text(address.fullAddress)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button("Change") {}
                                    .font(.caption)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Tip
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add a Tip")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            ForEach(tipOptions, id: \.self) { tip in
                                Button {
                                    selectedTip = tip
                                } label: {
                                    Text("\(tip)%")
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedTip == tip ? Color.orange : Color(.systemGray6))
                                        .foregroundColor(selectedTip == tip ? .white : .primary)
                                        .cornerRadius(12)
                                }
                            }
                        }
                    }
                    
                    // Payment Method
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "creditcard")
                            Text("•••• 4242")
                            Spacer()
                            Button("Change") {}
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Order Summary
                    if let restaurant = store.currentRestaurant {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Order Summary")
                                .font(.headline)
                            
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Subtotal")
                                    Spacer()
                                    Text(store.cartTotal, format: .currency(code: "USD"))
                                }
                                
                                HStack {
                                    Text("Delivery Fee")
                                    Spacer()
                                    Text(restaurant.deliveryFee, format: .currency(code: "USD"))
                                }
                                
                                HStack {
                                    Text("Service Fee")
                                    Spacer()
                                    Text(1.99, format: .currency(code: "USD"))
                                }
                                
                                HStack {
                                    Text("Tip")
                                    Spacer()
                                    Text(tipAmount, format: .currency(code: "USD"))
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Total")
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text(store.cartTotal + restaurant.deliveryFee + 1.99 + tipAmount, format: .currency(code: "USD"))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    placedOrder = store.placeOrder(tip: tipAmount)
                    showingOrderConfirmation = true
                } label: {
                    Text("Place Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
                .background(.bar)
            }
            .fullScreenCover(isPresented: $showingOrderConfirmation) {
                if let order = placedOrder {
                    OrderConfirmationViewFood(order: order)
                }
            }
        }
    }
}

// 13. Order Confirmation View
struct OrderConfirmationViewFood: View {
    let order: FoodOrder
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Order Placed!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Your order from \(order.restaurant.name) has been placed successfully.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Estimated Delivery")
                    Spacer()
                    Text(order.estimatedDelivery, style: .time)
                        .fontWeight(.semibold)
                }
                
                HStack {
                    Text("Order Total")
                    Spacer()
                    Text(order.total, format: .currency(code: "USD"))
                        .fontWeight(.semibold)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 12) {
                NavigationLink {
                    OrderTrackingView(order: order)
                } label: {
                    Text("Track Order")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Back to Home")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}

// 14. Order Tracking View
struct OrderTrackingView: View {
    let order: FoodOrder
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Map Placeholder
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(height: 200)
                    .cornerRadius(16)
                    .overlay(
                        Image(systemName: "map")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                    )
                
                // Status Timeline
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(OrderStatus.allCases.enumerated()), id: \.element) { index, status in
                        if status != .cancelled {
                            StatusTimelineRow(
                                status: status,
                                isCompleted: OrderStatus.allCases.firstIndex(of: status)! <= OrderStatus.allCases.firstIndex(of: order.status)!,
                                isCurrent: status == order.status,
                                isLast: status == .delivered
                            )
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Order Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("Order Details")
                        .font(.headline)
                    
                    HStack {
                        Text("Order #")
                        Spacer()
                        Text(order.id.uuidString.prefix(8))
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Restaurant")
                        Spacer()
                        Text(order.restaurant.name)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Total")
                        Spacer()
                        Text(order.total, format: .currency(code: "USD"))
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Driver Info
                if let driverName = order.driverName {
                    HStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text(driverName)
                                .fontWeight(.semibold)
                            Text("Your Driver")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            // Call driver
                        } label: {
                            Image(systemName: "phone.fill")
                                .padding(12)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        
                        Button {
                            // Message driver
                        } label: {
                            Image(systemName: "message.fill")
                                .padding(12)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
            }
            .padding()
        }
        .navigationTitle("Track Order")
    }
}

struct StatusTimelineRow: View {
    let status: OrderStatus
    let isCompleted: Bool
    let isCurrent: Bool
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(isCompleted ? status.color : Color(.systemGray4))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: isCompleted ? "checkmark" : "")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                
                if !isLast {
                    Rectangle()
                        .fill(isCompleted ? status.color : Color(.systemGray4))
                        .frame(width: 2, height: 40)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(status.rawValue)
                    .fontWeight(isCurrent ? .semibold : .regular)
                    .foregroundColor(isCurrent ? .primary : .secondary)
                
                if isCurrent {
                    Text("Current status")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, isLast ? 0 : 16)
            
            Spacer()
        }
    }
}

// 15. Orders History View
struct OrdersHistoryView: View {
    @EnvironmentObject var store: FoodStore
    
    var body: some View {
        NavigationStack {
            Group {
                if store.orders.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bag")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No orders yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("Your order history will appear here")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List(store.orders) { order in
                        NavigationLink {
                            OrderTrackingView(order: order)
                        } label: {
                            OrderHistoryRow(order: order)
                        }
                    }
                }
            }
            .navigationTitle("Orders")
        }
    }
}

struct OrderHistoryRow: View {
    let order: FoodOrder
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .overlay(
                    Text(order.restaurant.cuisine.first?.icon ?? "🍽️")
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(order.restaurant.name)
                    .fontWeight(.semibold)
                
                Text(order.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(order.status.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(order.status.color.opacity(0.2))
                        .foregroundColor(order.status.color)
                        .cornerRadius(8)
                    
                    Text(order.total, format: .currency(code: "USD"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// 16. Search Food View
struct SearchFoodView: View {
    @EnvironmentObject var store: FoodStore
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchText.isEmpty {
                    // Popular Searches
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Popular Searches")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(["Pizza", "Burger", "Sushi", "Tacos", "Chinese"], id: \.self) { term in
                            Button {
                                searchText = term
                            } label: {
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.secondary)
                                    Text(term)
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .foregroundColor(.primary)
                        }
                        
                        Spacer()
                    }
                    .padding(.top)
                } else {
                    List(store.restaurants.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.cuisine.contains { $0.rawValue.localizedCaseInsensitiveContains(searchText) } }) { restaurant in
                        NavigationLink {
                            RestaurantDetailView(restaurant: restaurant)
                                .environmentObject(store)
                        } label: {
                            RestaurantRowCard(restaurant: restaurant)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search restaurants, cuisines")
        }
    }
}

// 17. Food Profile View
struct FoodProfileView: View {
    @EnvironmentObject var store: FoodStore
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("John Doe")
                                .font(.headline)
                            Text("+1 (555) 123-4567")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Addresses") {
                    ForEach(store.addresses) { address in
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.orange)
                            
                            VStack(alignment: .leading) {
                                Text(address.label)
                                    .fontWeight(.medium)
                                Text(address.fullAddress)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if address.isDefault {
                                Text("Default")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Button("Add New Address", systemImage: "plus.circle") {}
                }
                
                Section("Payment") {
                    NavigationLink("Payment Methods", systemImage: "creditcard") {}
                    NavigationLink("Promotions", systemImage: "tag") {}
                }
                
                Section("Favorites") {
                    NavigationLink {
                        // Favorites list
                    } label: {
                        HStack {
                            Image(systemName: "heart")
                            Text("Favorite Restaurants")
                            Spacer()
                            Text("\(store.favoriteRestaurants.count)")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Settings") {
                    NavigationLink("Notifications", systemImage: "bell") {}
                    NavigationLink("Preferences", systemImage: "gearshape") {}
                    NavigationLink("Help & Support", systemImage: "questionmark.circle") {}
                }
                
                Section {
                    Button("Sign Out", role: .destructive) {}
                }
            }
            .navigationTitle("Account")
        }
    }
}

// MARK: - App Entry Point

public struct FoodDeliveryApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            FoodDeliveryHomeView()
        }
    }
}
