// MARK: - E-Commerce Template
// Complete e-commerce app template with 15+ screens, full navigation, sample data
// Dark mode ready, localized, accessible

import SwiftUI
import Foundation
import Combine

// MARK: - Models

public struct Product: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let description: String
    public let price: Decimal
    public let originalPrice: Decimal?
    public let images: [String]
    public let category: ProductCategory
    public let rating: Double
    public let reviewCount: Int
    public let inStock: Bool
    public let sizes: [String]
    public let colors: [ProductColor]
    public let specifications: [String: String]
    
    public init(
        id: UUID = UUID(),
        name: String,
        description: String,
        price: Decimal,
        originalPrice: Decimal? = nil,
        images: [String] = [],
        category: ProductCategory = .electronics,
        rating: Double = 4.5,
        reviewCount: Int = 100,
        inStock: Bool = true,
        sizes: [String] = [],
        colors: [ProductColor] = [],
        specifications: [String: String] = [:]
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.originalPrice = originalPrice
        self.images = images
        self.category = category
        self.rating = rating
        self.reviewCount = reviewCount
        self.inStock = inStock
        self.sizes = sizes
        self.colors = colors
        self.specifications = specifications
    }
}

public enum ProductCategory: String, Codable, CaseIterable {
    case electronics = "Electronics"
    case clothing = "Clothing"
    case home = "Home & Garden"
    case beauty = "Beauty"
    case sports = "Sports"
    case books = "Books"
    case toys = "Toys"
    case food = "Food & Grocery"
}

public struct ProductColor: Identifiable, Codable, Hashable {
    public let id: UUID
    public let name: String
    public let hexCode: String
    
    public init(id: UUID = UUID(), name: String, hexCode: String) {
        self.id = id
        self.name = name
        self.hexCode = hexCode
    }
}

public struct CartItem: Identifiable, Codable {
    public let id: UUID
    public let product: Product
    public var quantity: Int
    public var selectedSize: String?
    public var selectedColor: ProductColor?
    
    public init(
        id: UUID = UUID(),
        product: Product,
        quantity: Int = 1,
        selectedSize: String? = nil,
        selectedColor: ProductColor? = nil
    ) {
        self.id = id
        self.product = product
        self.quantity = quantity
        self.selectedSize = selectedSize
        self.selectedColor = selectedColor
    }
    
    public var totalPrice: Decimal {
        product.price * Decimal(quantity)
    }
}

public struct Order: Identifiable, Codable {
    public let id: UUID
    public let items: [CartItem]
    public let totalAmount: Decimal
    public let shippingAddress: ShippingAddress
    public let paymentMethod: PaymentMethod
    public let status: OrderStatus
    public let createdAt: Date
    public let estimatedDelivery: Date
    
    public init(
        id: UUID = UUID(),
        items: [CartItem],
        totalAmount: Decimal,
        shippingAddress: ShippingAddress,
        paymentMethod: PaymentMethod,
        status: OrderStatus = .pending,
        createdAt: Date = Date(),
        estimatedDelivery: Date = Date().addingTimeInterval(86400 * 5)
    ) {
        self.id = id
        self.items = items
        self.totalAmount = totalAmount
        self.shippingAddress = shippingAddress
        self.paymentMethod = paymentMethod
        self.status = status
        self.createdAt = createdAt
        self.estimatedDelivery = estimatedDelivery
    }
}

public enum OrderStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case confirmed = "Confirmed"
    case processing = "Processing"
    case shipped = "Shipped"
    case outForDelivery = "Out for Delivery"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    public var color: Color {
        switch self {
        case .pending: return .orange
        case .confirmed: return .blue
        case .processing: return .purple
        case .shipped: return .cyan
        case .outForDelivery: return .green
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
    
    public var icon: String {
        switch self {
        case .pending: return "clock"
        case .confirmed: return "checkmark.circle"
        case .processing: return "gearshape"
        case .shipped: return "box.truck"
        case .outForDelivery: return "truck"
        case .delivered: return "checkmark.seal.fill"
        case .cancelled: return "xmark.circle"
        }
    }
}

public struct ShippingAddress: Codable, Identifiable {
    public let id: UUID
    public var fullName: String
    public var addressLine1: String
    public var addressLine2: String?
    public var city: String
    public var state: String
    public var zipCode: String
    public var country: String
    public var phone: String
    public var isDefault: Bool
    
    public init(
        id: UUID = UUID(),
        fullName: String = "",
        addressLine1: String = "",
        addressLine2: String? = nil,
        city: String = "",
        state: String = "",
        zipCode: String = "",
        country: String = "United States",
        phone: String = "",
        isDefault: Bool = false
    ) {
        self.id = id
        self.fullName = fullName
        self.addressLine1 = addressLine1
        self.addressLine2 = addressLine2
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.phone = phone
        self.isDefault = isDefault
    }
}

public enum PaymentMethod: String, Codable, CaseIterable {
    case applePay = "Apple Pay"
    case creditCard = "Credit Card"
    case paypal = "PayPal"
    case klarna = "Klarna"
    case afterpay = "Afterpay"
    
    public var icon: String {
        switch self {
        case .applePay: return "apple.logo"
        case .creditCard: return "creditcard"
        case .paypal: return "p.circle"
        case .klarna: return "k.circle"
        case .afterpay: return "a.circle"
        }
    }
}

public struct Review: Identifiable, Codable {
    public let id: UUID
    public let productId: UUID
    public let userId: UUID
    public let userName: String
    public let userAvatar: String?
    public let rating: Int
    public let title: String
    public let content: String
    public let images: [String]
    public let helpful: Int
    public let createdAt: Date
    public let verified: Bool
    
    public init(
        id: UUID = UUID(),
        productId: UUID,
        userId: UUID = UUID(),
        userName: String,
        userAvatar: String? = nil,
        rating: Int,
        title: String,
        content: String,
        images: [String] = [],
        helpful: Int = 0,
        createdAt: Date = Date(),
        verified: Bool = true
    ) {
        self.id = id
        self.productId = productId
        self.userId = userId
        self.userName = userName
        self.userAvatar = userAvatar
        self.rating = rating
        self.title = title
        self.content = content
        self.images = images
        self.helpful = helpful
        self.createdAt = createdAt
        self.verified = verified
    }
}

// MARK: - Sample Data Provider

public enum ECommerceSampleData {
    public static let products: [Product] = [
        Product(
            name: "iPhone 15 Pro Max",
            description: "The most powerful iPhone ever with A17 Pro chip, titanium design, and advanced camera system.",
            price: 1199.00,
            originalPrice: 1299.00,
            images: ["iphone15_1", "iphone15_2", "iphone15_3"],
            category: .electronics,
            rating: 4.8,
            reviewCount: 2534,
            colors: [
                ProductColor(name: "Natural Titanium", hexCode: "#9A9892"),
                ProductColor(name: "Blue Titanium", hexCode: "#3B4664"),
                ProductColor(name: "White Titanium", hexCode: "#F2F1EB"),
                ProductColor(name: "Black Titanium", hexCode: "#3C3B37")
            ],
            specifications: [
                "Display": "6.7-inch Super Retina XDR",
                "Chip": "A17 Pro",
                "Camera": "48MP Main | 12MP Ultra Wide | 12MP Telephoto",
                "Battery": "Up to 29 hours video playback",
                "Storage": "256GB / 512GB / 1TB"
            ]
        ),
        Product(
            name: "MacBook Pro 16\"",
            description: "Supercharged by M3 Pro or M3 Max chip for unprecedented performance.",
            price: 2499.00,
            images: ["macbook_1", "macbook_2"],
            category: .electronics,
            rating: 4.9,
            reviewCount: 1876,
            colors: [
                ProductColor(name: "Space Black", hexCode: "#1D1D1F"),
                ProductColor(name: "Silver", hexCode: "#E3E4E5")
            ],
            specifications: [
                "Display": "16.2-inch Liquid Retina XDR",
                "Chip": "M3 Pro / M3 Max",
                "Memory": "18GB / 36GB / 48GB",
                "Storage": "512GB / 1TB / 2TB / 4TB / 8TB",
                "Battery": "Up to 22 hours"
            ]
        ),
        Product(
            name: "Nike Air Max 270",
            description: "Iconic design with revolutionary Air Max cushioning for all-day comfort.",
            price: 150.00,
            originalPrice: 180.00,
            images: ["nike_1", "nike_2", "nike_3"],
            category: .sports,
            rating: 4.6,
            reviewCount: 3421,
            sizes: ["7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "12"],
            colors: [
                ProductColor(name: "Black/White", hexCode: "#000000"),
                ProductColor(name: "University Red", hexCode: "#BA0C2F"),
                ProductColor(name: "Photo Blue", hexCode: "#0085CA")
            ]
        ),
        Product(
            name: "Premium Leather Jacket",
            description: "Handcrafted genuine leather jacket with modern slim fit design.",
            price: 349.00,
            images: ["jacket_1", "jacket_2"],
            category: .clothing,
            rating: 4.7,
            reviewCount: 892,
            sizes: ["XS", "S", "M", "L", "XL", "XXL"],
            colors: [
                ProductColor(name: "Black", hexCode: "#1C1C1C"),
                ProductColor(name: "Brown", hexCode: "#5C4033"),
                ProductColor(name: "Navy", hexCode: "#000080")
            ]
        ),
        Product(
            name: "Smart Home Hub",
            description: "Control all your smart devices from one central hub with voice support.",
            price: 129.00,
            images: ["smarthub_1"],
            category: .electronics,
            rating: 4.4,
            reviewCount: 567,
            colors: [
                ProductColor(name: "Charcoal", hexCode: "#36454F"),
                ProductColor(name: "Chalk", hexCode: "#F5F5F5")
            ]
        ),
        Product(
            name: "Organic Face Serum Set",
            description: "Complete skincare set with Vitamin C, Hyaluronic Acid, and Retinol serums.",
            price: 89.00,
            originalPrice: 120.00,
            images: ["serum_1", "serum_2"],
            category: .beauty,
            rating: 4.8,
            reviewCount: 2156
        ),
        Product(
            name: "Ergonomic Office Chair",
            description: "Premium mesh office chair with lumbar support and adjustable armrests.",
            price: 599.00,
            images: ["chair_1", "chair_2"],
            category: .home,
            rating: 4.5,
            reviewCount: 1234,
            colors: [
                ProductColor(name: "Black", hexCode: "#000000"),
                ProductColor(name: "Gray", hexCode: "#808080"),
                ProductColor(name: "Blue", hexCode: "#0066CC")
            ]
        ),
        Product(
            name: "Yoga Mat Premium",
            description: "Extra thick eco-friendly yoga mat with alignment lines.",
            price: 68.00,
            images: ["yoga_1"],
            category: .sports,
            rating: 4.7,
            reviewCount: 890,
            colors: [
                ProductColor(name: "Midnight Blue", hexCode: "#191970"),
                ProductColor(name: "Forest Green", hexCode: "#228B22"),
                ProductColor(name: "Purple", hexCode: "#800080")
            ]
        )
    ]
    
    public static let reviews: [Review] = [
        Review(
            productId: products[0].id,
            userName: "TechEnthusiast",
            rating: 5,
            title: "Best iPhone Ever!",
            content: "The camera system is incredible. The titanium design feels premium and the A17 Pro chip handles everything I throw at it.",
            helpful: 234,
            verified: true
        ),
        Review(
            productId: products[0].id,
            userName: "CasualUser",
            rating: 4,
            title: "Great phone, pricey",
            content: "Amazing phone overall but the price is steep. Action button is useful once you set it up.",
            helpful: 156,
            verified: true
        )
    ]
    
    public static let sampleAddress = ShippingAddress(
        fullName: "John Appleseed",
        addressLine1: "1 Apple Park Way",
        city: "Cupertino",
        state: "California",
        zipCode: "95014",
        country: "United States",
        phone: "+1 (408) 996-1010",
        isDefault: true
    )
}

// MARK: - ViewModels

@MainActor
public class ECommerceStore: ObservableObject {
    @Published public var products: [Product] = ECommerceSampleData.products
    @Published public var cart: [CartItem] = []
    @Published public var wishlist: Set<UUID> = []
    @Published public var orders: [Order] = []
    @Published public var addresses: [ShippingAddress] = [ECommerceSampleData.sampleAddress]
    @Published public var selectedPaymentMethod: PaymentMethod = .applePay
    @Published public var searchQuery: String = ""
    @Published public var selectedCategory: ProductCategory? = nil
    @Published public var sortOption: SortOption = .popular
    @Published public var isLoading: Bool = false
    
    public enum SortOption: String, CaseIterable {
        case popular = "Most Popular"
        case priceAsc = "Price: Low to High"
        case priceDesc = "Price: High to Low"
        case rating = "Highest Rated"
        case newest = "Newest"
    }
    
    public init() {}
    
    public var filteredProducts: [Product] {
        var result = products
        
        if !searchQuery.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchQuery) ||
                $0.description.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        switch sortOption {
        case .popular:
            result.sort { $0.reviewCount > $1.reviewCount }
        case .priceAsc:
            result.sort { $0.price < $1.price }
        case .priceDesc:
            result.sort { $0.price > $1.price }
        case .rating:
            result.sort { $0.rating > $1.rating }
        case .newest:
            break
        }
        
        return result
    }
    
    public var cartTotal: Decimal {
        cart.reduce(0) { $0 + $1.totalPrice }
    }
    
    public var cartItemCount: Int {
        cart.reduce(0) { $0 + $1.quantity }
    }
    
    public func addToCart(_ product: Product, size: String? = nil, color: ProductColor? = nil) {
        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            cart[index].quantity += 1
        } else {
            cart.append(CartItem(product: product, selectedSize: size, selectedColor: color))
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
    
    public func toggleWishlist(_ productId: UUID) {
        if wishlist.contains(productId) {
            wishlist.remove(productId)
        } else {
            wishlist.insert(productId)
        }
    }
    
    public func placeOrder(address: ShippingAddress) -> Order {
        let order = Order(
            items: cart,
            totalAmount: cartTotal,
            shippingAddress: address,
            paymentMethod: selectedPaymentMethod
        )
        orders.insert(order, at: 0)
        cart.removeAll()
        return order
    }
}

// MARK: - Views

// 1. Home Screen
public struct ECommerceHomeView: View {
    @StateObject private var store = ECommerceStore()
    @State private var showingCart = false
    @State private var showingProfile = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Bar
                    SearchBarView(text: $store.searchQuery)
                        .padding(.horizontal)
                    
                    // Featured Banner
                    FeaturedBannerView()
                    
                    // Categories
                    CategoryScrollView(
                        selectedCategory: $store.selectedCategory
                    )
                    
                    // Flash Sale Section
                    FlashSaleSectionView(products: store.products.prefix(4).map { $0 })
                        .environmentObject(store)
                    
                    // Product Grid
                    ProductGridView(products: store.filteredProducts)
                        .environmentObject(store)
                }
                .padding(.vertical)
            }
            .navigationTitle("Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CartButton(itemCount: store.cartItemCount) {
                        showingCart = true
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile = true
                    } label: {
                        Image(systemName: "person.circle")
                            .font(.title3)
                    }
                    .accessibilityLabel("Profile")
                }
            }
            .sheet(isPresented: $showingCart) {
                CartView()
                    .environmentObject(store)
            }
            .sheet(isPresented: $showingProfile) {
                ProfileView()
                    .environmentObject(store)
            }
        }
        .environmentObject(store)
    }
}

// 2. Search Bar Component
struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search products...", text: $text)
                .textFieldStyle(.plain)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Search products")
    }
}

// 3. Featured Banner
struct FeaturedBannerView: View {
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Summer Sale")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.9))
                
                Text("Up to 50% Off")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("On selected items")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                
                Button {
                    // Shop now action
                } label: {
                    Text("Shop Now")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(.white)
                        .foregroundColor(.purple)
                        .cornerRadius(20)
                }
                .padding(.top, 8)
            }
            .padding(24)
        }
        .frame(height: 180)
        .padding(.horizontal)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Summer sale banner. Up to 50% off on selected items.")
    }
}

// 4. Category Scroll View
struct CategoryScrollView: View {
    @Binding var selectedCategory: ProductCategory?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryChip(
                        title: "All",
                        icon: "square.grid.2x2",
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }
                    
                    ForEach(ProductCategory.allCases, id: \.self) { category in
                        CategoryChip(
                            title: category.rawValue,
                            icon: iconFor(category),
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func iconFor(_ category: ProductCategory) -> String {
        switch category {
        case .electronics: return "laptopcomputer"
        case .clothing: return "tshirt"
        case .home: return "house"
        case .beauty: return "sparkles"
        case .sports: return "figure.run"
        case .books: return "book"
        case .toys: return "gamecontroller"
        case .food: return "carrot"
        }
    }
}

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.accentColor : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// 5. Flash Sale Section
struct FlashSaleSectionView: View {
    @EnvironmentObject var store: ECommerceStore
    let products: [Product]
    @State private var timeRemaining = 3600 * 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("⚡ Flash Sale")
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(timeString)
                }
                .font(.subheadline)
                .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(products) { product in
                        FlashSaleCard(product: product)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var timeString: String {
        let hours = timeRemaining / 3600
        let minutes = (timeRemaining % 3600) / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct FlashSaleCard: View {
    @EnvironmentObject var store: ECommerceStore
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    )
                
                if let originalPrice = product.originalPrice {
                    let discount = Int(((originalPrice - product.price) / originalPrice) * 100)
                    Text("-\(discount)%")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(6)
                        .background(.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(8)
                }
            }
            
            Text(product.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
            
            HStack {
                Text(product.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
                
                if let original = product.originalPrice {
                    Text(original, format: .currency(code: "USD"))
                        .font(.caption)
                        .strikethrough()
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: 140)
        .accessibilityElement(children: .combine)
    }
}

// 6. Product Grid
struct ProductGridView: View {
    @EnvironmentObject var store: ECommerceStore
    let products: [Product]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All Products")
                    .font(.headline)
                
                Spacer()
                
                Menu {
                    ForEach(ECommerceStore.SortOption.allCases, id: \.self) { option in
                        Button {
                            store.sortOption = option
                        } label: {
                            HStack {
                                Text(option.rawValue)
                                if store.sortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text("Sort")
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .font(.subheadline)
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(products) { product in
                    NavigationLink {
                        ProductDetailView(product: product)
                            .environmentObject(store)
                    } label: {
                        ProductCard(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

// 7. Product Card
struct ProductCard: View {
    @EnvironmentObject var store: ECommerceStore
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: iconFor(product.category))
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                    )
                
                Button {
                    store.toggleWishlist(product.id)
                } label: {
                    Image(systemName: store.wishlist.contains(product.id) ? "heart.fill" : "heart")
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .foregroundColor(store.wishlist.contains(product.id) ? .red : .primary)
                }
                .padding(8)
                .accessibilityLabel(store.wishlist.contains(product.id) ? "Remove from wishlist" : "Add to wishlist")
            }
            
            Text(product.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", product.rating))
                Text("(\(product.reviewCount))")
                    .foregroundColor(.secondary)
            }
            .font(.caption)
            
            HStack {
                Text(product.price, format: .currency(code: "USD"))
                    .font(.headline)
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                Button {
                    store.addToCart(product)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .accessibilityLabel("Add to cart")
            }
        }
        .accessibilityElement(children: .combine)
    }
    
    private func iconFor(_ category: ProductCategory) -> String {
        switch category {
        case .electronics: return "laptopcomputer"
        case .clothing: return "tshirt.fill"
        case .home: return "house.fill"
        case .beauty: return "sparkles"
        case .sports: return "figure.run"
        case .books: return "book.fill"
        case .toys: return "gamecontroller.fill"
        case .food: return "carrot.fill"
        }
    }
}

// 8. Product Detail View
public struct ProductDetailView: View {
    @EnvironmentObject var store: ECommerceStore
    @Environment(\.dismiss) private var dismiss
    let product: Product
    
    @State private var selectedSize: String?
    @State private var selectedColor: ProductColor?
    @State private var quantity = 1
    @State private var selectedImageIndex = 0
    @State private var showingReviews = false
    
    public init(product: Product) {
        self.product = product
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Image Gallery
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<max(1, product.images.count), id: \.self) { index in
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(.systemGray6))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 60))
                                    .foregroundColor(.secondary)
                            )
                            .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 350)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and Price
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.category.rawValue)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(product.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(product.price, format: .currency(code: "USD"))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.accentColor)
                            
                            if let original = product.originalPrice {
                                Text(original, format: .currency(code: "USD"))
                                    .font(.title3)
                                    .strikethrough()
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Rating
                    Button {
                        showingReviews = true
                    } label: {
                        HStack(spacing: 8) {
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= Int(product.rating) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            Text(String(format: "%.1f", product.rating))
                                .fontWeight(.semibold)
                            
                            Text("(\(product.reviewCount) reviews)")
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                    }
                    .buttonStyle(.plain)
                    
                    Divider()
                    
                    // Colors
                    if !product.colors.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Color")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                ForEach(product.colors) { color in
                                    Button {
                                        selectedColor = color
                                    } label: {
                                        Circle()
                                            .fill(Color(hex: color.hexCode))
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedColor?.id == color.id ? Color.accentColor : Color.clear, lineWidth: 3)
                                                    .padding(-4)
                                            )
                                    }
                                    .accessibilityLabel(color.name)
                                    .accessibilityAddTraits(selectedColor?.id == color.id ? .isSelected : [])
                                }
                            }
                        }
                    }
                    
                    // Sizes
                    if !product.sizes.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Size")
                                    .font(.headline)
                                Spacer()
                                Button("Size Guide") {}
                                    .font(.subheadline)
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
                                ForEach(product.sizes, id: \.self) { size in
                                    Button {
                                        selectedSize = size
                                    } label: {
                                        Text(size)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(selectedSize == size ? Color.accentColor : Color(.systemGray6))
                                            .foregroundColor(selectedSize == size ? .white : .primary)
                                            .cornerRadius(8)
                                    }
                                    .accessibilityAddTraits(selectedSize == size ? .isSelected : [])
                                }
                            }
                        }
                    }
                    
                    // Quantity
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Quantity")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            Button {
                                if quantity > 1 { quantity -= 1 }
                            } label: {
                                Image(systemName: "minus.circle")
                                    .font(.title2)
                            }
                            .disabled(quantity <= 1)
                            
                            Text("\(quantity)")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .frame(width: 40)
                            
                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus.circle")
                                    .font(.title2)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Specifications
                    if !product.specifications.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Specifications")
                                .font(.headline)
                            
                            ForEach(Array(product.specifications.keys.sorted()), id: \.self) { key in
                                HStack {
                                    Text(key)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(product.specifications[key] ?? "")
                                }
                                .font(.subheadline)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                Divider()
                HStack(spacing: 16) {
                    Button {
                        store.toggleWishlist(product.id)
                    } label: {
                        Image(systemName: store.wishlist.contains(product.id) ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(store.wishlist.contains(product.id) ? .red : .primary)
                            .frame(width: 50, height: 50)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    Button {
                        for _ in 0..<quantity {
                            store.addToCart(product, size: selectedSize, color: selectedColor)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "cart.badge.plus")
                            Text("Add to Cart")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(!product.inStock)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(.bar)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Share action
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingReviews) {
            ReviewsView(product: product)
        }
    }
}

// 9. Cart View
public struct CartView: View {
    @EnvironmentObject var store: ECommerceStore
    @Environment(\.dismiss) private var dismiss
    @State private var showingCheckout = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            Group {
                if store.cart.isEmpty {
                    EmptyCartView()
                } else {
                    CartContentView(showingCheckout: $showingCheckout)
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
            .sheet(isPresented: $showingCheckout) {
                CheckoutView()
                    .environmentObject(store)
            }
        }
    }
}

struct EmptyCartView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add some items to get started")
                .foregroundColor(.secondary)
            
            Button("Continue Shopping") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct CartContentView: View {
    @EnvironmentObject var store: ECommerceStore
    @Binding var showingCheckout: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            List {
                ForEach(store.cart) { item in
                    CartItemRow(item: item)
                }
                .onDelete { indexSet in
                    indexSet.forEach { store.cart.remove(at: $0) }
                }
            }
            .listStyle(.plain)
            
            // Summary
            VStack(spacing: 12) {
                Divider()
                
                VStack(spacing: 8) {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(store.cartTotal, format: .currency(code: "USD"))
                    }
                    
                    HStack {
                        Text("Shipping")
                        Spacer()
                        Text("Free")
                            .foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(store.cartTotal, format: .currency(code: "USD"))
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                .font(.subheadline)
                .padding(.horizontal)
                
                Button {
                    showingCheckout = true
                } label: {
                    Text("Proceed to Checkout")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(.bar)
        }
    }
}

struct CartItemRow: View {
    @EnvironmentObject var store: ECommerceStore
    let item: CartItem
    
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                if let size = item.selectedSize {
                    Text("Size: \(size)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let color = item.selectedColor {
                    Text("Color: \(color.name)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(item.totalPrice, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Stepper("Qty: \(item.quantity)", value: Binding(
                    get: { item.quantity },
                    set: { store.updateQuantity(item, quantity: $0) }
                ), in: 1...10)
                .font(.caption)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// 10. Checkout View
public struct CheckoutView: View {
    @EnvironmentObject var store: ECommerceStore
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAddress: ShippingAddress?
    @State private var showingOrderConfirmation = false
    @State private var placedOrder: Order?
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Shipping Address
                    AddressSectionView(selectedAddress: $selectedAddress, addresses: store.addresses)
                    
                    // Payment Method
                    PaymentSectionView(selectedMethod: $store.selectedPaymentMethod)
                    
                    // Order Summary
                    OrderSummaryView(items: store.cart, total: store.cartTotal)
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
                VStack(spacing: 12) {
                    Divider()
                    
                    Button {
                        if let address = selectedAddress ?? store.addresses.first {
                            placedOrder = store.placeOrder(address: address)
                            showingOrderConfirmation = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: store.selectedPaymentMethod.icon)
                            Text("Pay \(store.cartTotal, format: .currency(code: "USD"))")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .background(.bar)
            }
            .sheet(isPresented: $showingOrderConfirmation) {
                if let order = placedOrder {
                    OrderConfirmationView(order: order) {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddressSectionView: View {
    @Binding var selectedAddress: ShippingAddress?
    let addresses: [ShippingAddress]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shipping Address")
                .font(.headline)
            
            ForEach(addresses) { address in
                Button {
                    selectedAddress = address
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(address.fullName)
                                .fontWeight(.medium)
                            Text(address.addressLine1)
                            Text("\(address.city), \(address.state) \(address.zipCode)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        if selectedAddress?.id == address.id || (selectedAddress == nil && address.isDefault) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            
            Button {
                // Add new address
            } label: {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add New Address")
                }
                .font(.subheadline)
            }
        }
    }
}

struct PaymentSectionView: View {
    @Binding var selectedMethod: PaymentMethod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(.headline)
            
            ForEach(PaymentMethod.allCases, id: \.self) { method in
                Button {
                    selectedMethod = method
                } label: {
                    HStack {
                        Image(systemName: method.icon)
                            .frame(width: 30)
                        
                        Text(method.rawValue)
                        
                        Spacer()
                        
                        if selectedMethod == method {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
        }
    }
}

struct OrderSummaryView: View {
    let items: [CartItem]
    let total: Decimal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(items) { item in
                    HStack {
                        Text(item.product.name)
                            .lineLimit(1)
                        Text("×\(item.quantity)")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(item.totalPrice, format: .currency(code: "USD"))
                    }
                    .font(.subheadline)
                }
                
                Divider()
                
                HStack {
                    Text("Shipping")
                    Spacer()
                    Text("Free")
                        .foregroundColor(.green)
                }
                .font(.subheadline)
                
                HStack {
                    Text("Total")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(total, format: .currency(code: "USD"))
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// 11. Order Confirmation View
struct OrderConfirmationView: View {
    let order: Order
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Order Placed!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Order #\(order.id.uuidString.prefix(8))")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("Estimated Delivery")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(order.estimatedDelivery, style: .date)
                    .font(.headline)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            Button {
                onDismiss()
            } label: {
                Text("Continue Shopping")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

// 12. Reviews View
struct ReviewsView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Rating Summary
                    HStack(spacing: 20) {
                        VStack {
                            Text(String(format: "%.1f", product.rating))
                                .font(.system(size: 48, weight: .bold))
                            
                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { star in
                                    Image(systemName: star <= Int(product.rating) ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                            }
                            
                            Text("\(product.reviewCount) reviews")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            RatingBar(label: "5", value: 0.7)
                            RatingBar(label: "4", value: 0.2)
                            RatingBar(label: "3", value: 0.06)
                            RatingBar(label: "2", value: 0.03)
                            RatingBar(label: "1", value: 0.01)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Reviews List
                    ForEach(ECommerceSampleData.reviews.filter { $0.productId == product.id }) { review in
                        ReviewCard(review: review)
                    }
                }
                .padding()
            }
            .navigationTitle("Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct RatingBar: View {
    let label: String
    let value: Double
    
    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .frame(width: 10)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: geometry.size.width * value)
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
        }
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(.systemGray4))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(review.userName.prefix(1))
                            .fontWeight(.semibold)
                    )
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(review.userName)
                            .fontWeight(.medium)
                        
                        if review.verified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.green)
                                .font(.caption)
                        }
                    }
                    
                    Text(review.createdAt, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            
            Text(review.title)
                .fontWeight(.semibold)
            
            Text(review.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Button {
                    // Mark helpful
                } label: {
                    HStack {
                        Image(systemName: "hand.thumbsup")
                        Text("Helpful (\(review.helpful))")
                    }
                    .font(.caption)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 13. Profile View
public struct ProfileView: View {
    @EnvironmentObject var store: ECommerceStore
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            List {
                // User Info
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading) {
                            Text("John Appleseed")
                                .font(.headline)
                            Text("john@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Orders
                Section("Orders") {
                    NavigationLink {
                        OrdersListView()
                            .environmentObject(store)
                    } label: {
                        Label("My Orders", systemImage: "bag")
                    }
                    
                    NavigationLink {
                        // Returns
                    } label: {
                        Label("Returns", systemImage: "arrow.uturn.left")
                    }
                }
                
                // Account
                Section("Account") {
                    NavigationLink {
                        // Addresses
                    } label: {
                        Label("Addresses", systemImage: "location")
                    }
                    
                    NavigationLink {
                        // Payment Methods
                    } label: {
                        Label("Payment Methods", systemImage: "creditcard")
                    }
                    
                    NavigationLink {
                        WishlistView()
                            .environmentObject(store)
                    } label: {
                        Label {
                            HStack {
                                Text("Wishlist")
                                Spacer()
                                Text("\(store.wishlist.count)")
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "heart")
                        }
                    }
                }
                
                // Settings
                Section("Settings") {
                    NavigationLink {
                        // Notifications
                    } label: {
                        Label("Notifications", systemImage: "bell")
                    }
                    
                    NavigationLink {
                        // Privacy
                    } label: {
                        Label("Privacy", systemImage: "lock")
                    }
                    
                    NavigationLink {
                        // Help
                    } label: {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                }
                
                // Sign Out
                Section {
                    Button(role: .destructive) {
                        // Sign out
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// 14. Orders List View
struct OrdersListView: View {
    @EnvironmentObject var store: ECommerceStore
    
    var body: some View {
        Group {
            if store.orders.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bag")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("No orders yet")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Start shopping to see your orders here")
                        .foregroundColor(.secondary)
                }
            } else {
                List(store.orders) { order in
                    NavigationLink {
                        OrderDetailView(order: order)
                    } label: {
                        OrderRowView(order: order)
                    }
                }
            }
        }
        .navigationTitle("My Orders")
    }
}

struct OrderRowView: View {
    let order: Order
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Order #\(order.id.uuidString.prefix(8))")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(order.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(order.status.color.opacity(0.2))
                    .foregroundColor(order.status.color)
                    .cornerRadius(8)
            }
            
            Text("\(order.items.count) items • \(order.totalAmount, format: .currency(code: "USD"))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(order.createdAt, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// 15. Order Detail View
struct OrderDetailView: View {
    let order: Order
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Status Timeline
                VStack(alignment: .leading, spacing: 16) {
                    Text("Order Status")
                        .font(.headline)
                    
                    ForEach(OrderStatus.allCases.prefix(while: { status in
                        OrderStatus.allCases.firstIndex(of: status)! <= OrderStatus.allCases.firstIndex(of: order.status)!
                    }), id: \.self) { status in
                        HStack(spacing: 12) {
                            Image(systemName: status.icon)
                                .foregroundColor(status == order.status ? status.color : .secondary)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading) {
                                Text(status.rawValue)
                                    .fontWeight(status == order.status ? .semibold : .regular)
                            }
                            
                            Spacer()
                            
                            if status == order.status {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Items
                VStack(alignment: .leading, spacing: 12) {
                    Text("Items")
                        .font(.headline)
                    
                    ForEach(order.items) { item in
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray5))
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(item.product.name)
                                    .font(.subheadline)
                                Text("Qty: \(item.quantity)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Text(item.totalPrice, format: .currency(code: "USD"))
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Shipping Address
                VStack(alignment: .leading, spacing: 8) {
                    Text("Shipping Address")
                        .font(.headline)
                    
                    Text(order.shippingAddress.fullName)
                    Text(order.shippingAddress.addressLine1)
                    Text("\(order.shippingAddress.city), \(order.shippingAddress.state) \(order.shippingAddress.zipCode)")
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Total
                VStack(spacing: 8) {
                    HStack {
                        Text("Total")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(order.totalAmount, format: .currency(code: "USD"))
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Order Details")
    }
}

// 16. Wishlist View
struct WishlistView: View {
    @EnvironmentObject var store: ECommerceStore
    
    var wishlistProducts: [Product] {
        store.products.filter { store.wishlist.contains($0.id) }
    }
    
    var body: some View {
        Group {
            if wishlistProducts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "heart")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text("Your wishlist is empty")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Save items you love by tapping the heart")
                        .foregroundColor(.secondary)
                }
            } else {
                List(wishlistProducts) { product in
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(width: 80, height: 80)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .fontWeight(.medium)
                            
                            Text(product.price, format: .currency(code: "USD"))
                                .foregroundColor(.accentColor)
                        }
                        
                        Spacer()
                        
                        Button {
                            store.addToCart(product)
                        } label: {
                            Image(systemName: "cart.badge.plus")
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            store.toggleWishlist(product.id)
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Wishlist")
    }
}

// Cart Button Component
struct CartButton: View {
    let itemCount: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "cart")
                    .font(.title3)
                
                if itemCount > 0 {
                    Text("\(itemCount)")
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
        .accessibilityLabel("Cart, \(itemCount) items")
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - App Entry Point

public struct ECommerceApp: App {
    public init() {}
    
    public var body: some Scene {
        WindowGroup {
            ECommerceHomeView()
        }
    }
}
