import Foundation
import SwiftUI

// MARK: - Commerce Templates
public struct CommerceTemplates {
    
    // MARK: - Version
    public static let version = "2.1.0"
    
    // MARK: - Initialization
    public static func initialize() {
        print("🛒 Commerce Templates v\(version) initialized")
    }
}

// MARK: - E-commerce App Template
public struct EcommerceAppTemplate {
    
    // MARK: - Models
    public struct Product: Identifiable, Codable {
        public let id: String
        public let name: String
        public let description: String
        public let price: Double
        public let originalPrice: Double?
        public let currency: String
        public let images: [String]
        public let category: String
        public let brand: String
        public let sku: String
        public let stockQuantity: Int
        public let isAvailable: Bool
        public let rating: Double
        public let reviewCount: Int
        public let tags: [String]
        public let specifications: [String: String]
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String,
            name: String,
            description: String,
            price: Double,
            originalPrice: Double? = nil,
            currency: String = "USD",
            images: [String] = [],
            category: String,
            brand: String,
            sku: String,
            stockQuantity: Int = 0,
            isAvailable: Bool = true,
            rating: Double = 0.0,
            reviewCount: Int = 0,
            tags: [String] = [],
            specifications: [String: String] = [:],
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.price = price
            self.originalPrice = originalPrice
            self.currency = currency
            self.images = images
            self.category = category
            self.brand = brand
            self.sku = sku
            self.stockQuantity = stockQuantity
            self.isAvailable = isAvailable
            self.rating = rating
            self.reviewCount = reviewCount
            self.tags = tags
            self.specifications = specifications
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct CartItem: Identifiable, Codable {
        public let id: String
        public let productId: String
        public let productName: String
        public let productImage: String?
        public let price: Double
        public var quantity: Int
        
        public init(
            id: String,
            productId: String,
            productName: String,
            productImage: String? = nil,
            price: Double,
            quantity: Int = 1
        ) {
            self.id = id
            self.productId = productId
            self.productName = productName
            self.productImage = productImage
            self.price = price
            self.quantity = quantity
        }

        public var totalPrice: Double {
            price * Double(quantity)
        }
    }
    
    public struct Order: Identifiable, Codable {
        public let id: String
        public let userId: String
        public let items: [CartItem]
        public let subtotal: Double
        public let tax: Double
        public let shipping: Double
        public let total: Double
        public var status: OrderStatus
        public let shippingAddress: Address
        public let billingAddress: Address
        public let paymentMethod: PaymentMethod
        public let createdAt: Date
        public let updatedAt: Date
        
        public init(
            id: String,
            userId: String,
            items: [CartItem],
            subtotal: Double,
            tax: Double,
            shipping: Double,
            total: Double,
            status: OrderStatus = .pending,
            shippingAddress: Address,
            billingAddress: Address,
            paymentMethod: PaymentMethod,
            createdAt: Date = Date(),
            updatedAt: Date = Date()
        ) {
            self.id = id
            self.userId = userId
            self.items = items
            self.subtotal = subtotal
            self.tax = tax
            self.shipping = shipping
            self.total = total
            self.status = status
            self.shippingAddress = shippingAddress
            self.billingAddress = billingAddress
            self.paymentMethod = paymentMethod
            self.createdAt = createdAt
            self.updatedAt = updatedAt
        }
    }
    
    public struct Address: Codable {
        public let firstName: String
        public let lastName: String
        public let street: String
        public let city: String
        public let state: String
        public let zipCode: String
        public let country: String
        public let phone: String?
        
        public init(
            firstName: String,
            lastName: String,
            street: String,
            city: String,
            state: String,
            zipCode: String,
            country: String,
            phone: String? = nil
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.street = street
            self.city = city
            self.state = state
            self.zipCode = zipCode
            self.country = country
            self.phone = phone
        }
    }
    
    public struct PaymentMethod: Codable {
        public let id: String
        public let type: PaymentType
        public let last4: String?
        public let brand: String?
        public let expiryMonth: Int?
        public let expiryYear: Int?
        
        public init(
            id: String,
            type: PaymentType,
            last4: String? = nil,
            brand: String? = nil,
            expiryMonth: Int? = nil,
            expiryYear: Int? = nil
        ) {
            self.id = id
            self.type = type
            self.last4 = last4
            self.brand = brand
            self.expiryMonth = expiryMonth
            self.expiryYear = expiryYear
        }
    }
    
    public enum OrderStatus: String, CaseIterable, Codable {
        case pending = "pending"
        case confirmed = "confirmed"
        case processing = "processing"
        case shipped = "shipped"
        case delivered = "delivered"
        case cancelled = "cancelled"
        case refunded = "refunded"
        
        public var displayName: String {
            switch self {
            case .pending: return "Pending"
            case .confirmed: return "Confirmed"
            case .processing: return "Processing"
            case .shipped: return "Shipped"
            case .delivered: return "Delivered"
            case .cancelled: return "Cancelled"
            case .refunded: return "Refunded"
            }
        }
        
        public var color: String {
            switch self {
            case .pending: return "orange"
            case .confirmed: return "blue"
            case .processing: return "purple"
            case .shipped: return "cyan"
            case .delivered: return "green"
            case .cancelled: return "red"
            case .refunded: return "gray"
            }
        }
    }
    
    public enum PaymentType: String, CaseIterable, Codable {
        case creditCard = "credit_card"
        case debitCard = "debit_card"
        case paypal = "paypal"
        case applePay = "apple_pay"
        case googlePay = "google_pay"
        case bankTransfer = "bank_transfer"
        case cash = "cash"
        
        public var displayName: String {
            switch self {
            case .creditCard: return "Credit Card"
            case .debitCard: return "Debit Card"
            case .paypal: return "PayPal"
            case .applePay: return "Apple Pay"
            case .googlePay: return "Google Pay"
            case .bankTransfer: return "Bank Transfer"
            case .cash: return "Cash"
            }
        }
    }
    
    // MARK: - Managers
    @MainActor
    public class ProductManager: ObservableObject {
        
        @Published public var products: [Product] = []
        @Published public var isLoading = false
        @Published public var categories: [String] = []
        @Published public var brands: [String] = []
        
        public init() {}
        
        // MARK: - Product Methods
        
        public func fetchProducts(category: String? = nil, brand: String? = nil, searchQuery: String? = nil) async throws {
            isLoading = true
            defer { isLoading = false }
            
            // Mock native data
            self.products = [
                Product(id: "1", name: "Native Power", description: "Zero bloat, pure Swift.", price: 99.99, category: "Software", brand: "Muhittin", sku: "SW-01"),
                Product(id: "2", name: "Liquid Glass UI", description: "iOS 26 ready styles.", price: 49.99, category: "UI", brand: "Muhittin", sku: "UI-01")
            ]
        }
        
        public func fetchCategories() async throws {
            self.categories = ["Software", "UI", "Hardware"]
        }
        
        public func fetchBrands() async throws {
            self.brands = ["Muhittin", "Swift", "Apple"]
        }
        
        public func getProduct(by id: String) async throws -> Product? {
            return products.first { $0.id == id }
        }
    }
    
    @MainActor
    public class CartManager: ObservableObject {
        
        @Published public var items: [CartItem] = []
        @Published public var isLoading = false
        
        public init() {}
        
        // MARK: - Cart Methods
        
        public func addToCart(_ product: Product, quantity: Int = 1) {
            if let existingIndex = items.firstIndex(where: { $0.productId == product.id }) {
                items[existingIndex].quantity += quantity
            } else {
                let cartItem = CartItem(
                    id: UUID().uuidString,
                    productId: product.id,
                    productName: product.name,
                    productImage: product.images.first,
                    price: product.price,
                    quantity: quantity
                )
                items.append(cartItem)
            }
        }
        
        public func removeFromCart(_ item: CartItem) {
            items.removeAll { $0.id == item.id }
        }
        
        public func updateQuantity(for item: CartItem, quantity: Int) {
            if let index = items.firstIndex(where: { $0.id == item.id }) {
                items[index].quantity = max(1, quantity)
            }
        }
        
        public func clearCart() {
            items.removeAll()
        }
        
        public var totalItems: Int {
            items.reduce(0) { $0 + $1.quantity }
        }
        
        public var subtotal: Double {
            items.reduce(0) { $0 + $1.totalPrice }
        }
        
        public var tax: Double {
            subtotal * 0.08 // 8% tax rate
        }
        
        public var shipping: Double {
            subtotal > 50 ? 0 : 5.99 // Free shipping over $50
        }
        
        public var total: Double {
            subtotal + tax + shipping
        }
    }
    
    @MainActor
    public class OrderManager: ObservableObject {
        
        @Published public var orders: [Order] = []
        @Published public var isLoading = false
        
        public init() {}
        
        // MARK: - Order Methods
        
        public func createOrder(
            items: [CartItem],
            shippingAddress: Address,
            billingAddress: Address,
            paymentMethod: PaymentMethod
        ) async throws -> Order {
            isLoading = true
            defer { isLoading = false }
            
            let subtotal = items.reduce(0) { $0 + $1.totalPrice }
            let tax = subtotal * 0.08
            let shipping = subtotal > 50 ? 0 : 5.99
            let total = subtotal + tax + shipping
            
            let order = Order(
                id: UUID().uuidString,
                userId: "mock_user",
                items: items,
                subtotal: subtotal,
                tax: tax,
                shipping: shipping,
                total: total,
                shippingAddress: shippingAddress,
                billingAddress: billingAddress,
                paymentMethod: paymentMethod
            )
            
            orders.insert(order, at: 0)
            return order
        }
        
        public func fetchOrders() async throws {
            isLoading = true
            defer { isLoading = false }
            // Stubbed
        }
        
        public func updateOrderStatus(_ order: Order, status: OrderStatus) async throws {
            if let index = orders.firstIndex(where: { $0.id == order.id }) {
                orders[index].status = status
            }
        }
    }
    
    // MARK: - UI Components
    
    public struct ProductCard: View {
        let product: Product
        let onAddToCart: () -> Void
        let onViewDetails: () -> Void
        
        public init(
            product: Product,
            onAddToCart: @escaping () -> Void,
            onViewDetails: @escaping () -> Void
        ) {
            self.product = product
            self.onAddToCart = onAddToCart
            self.onViewDetails = onViewDetails
        }
        
        public var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                // Product Image
                if let firstImage = product.images.first {
                    AsyncImage(url: URL(string: firstImage)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 150)
                        .cornerRadius(8)
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                
                // Product Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.name)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(product.brand)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        if let originalPrice = product.originalPrice, originalPrice > product.price {
                            Text("$\(String(format: "%.2f", originalPrice))")
                                .font(.caption)
                                .strikethrough()
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", product.rating))
                                .font(.caption)
                        }
                    }
                }
                
                // Action Buttons
                HStack {
                    Button(action: onViewDetails) {
                        Text("Details")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Button(action: onAddToCart) {
                        Image(systemName: "cart.badge.plus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
    
    // MARK: - Errors
    
    public enum CommerceError: LocalizedError {
        case userNotAuthenticated
        case productNotFound
        case insufficientStock
        case invalidPaymentMethod
        case orderCreationFailed
        case networkError
        
        public var errorDescription: String? {
            switch self {
            case .userNotAuthenticated:
                return "User not authenticated"
            case .productNotFound:
                return "Product not found"
            case .insufficientStock:
                return "Insufficient stock"
            case .invalidPaymentMethod:
                return "Invalid payment method"
            case .orderCreationFailed:
                return "Order creation failed"
            case .networkError:
                return "Network error occurred"
            }
        }
    }
}
