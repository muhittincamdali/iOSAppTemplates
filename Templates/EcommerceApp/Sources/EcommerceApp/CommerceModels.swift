import Foundation
import SwiftUI

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
    var fulfillmentLane: CommerceFulfillmentLane
    var returnStatus: CommerceReturnStatus

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
        supportStatus: String,
        fulfillmentLane: CommerceFulfillmentLane,
        returnStatus: CommerceReturnStatus
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
        self.fulfillmentLane = fulfillmentLane
        self.returnStatus = returnStatus
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
                supportStatus: "Healthy",
                fulfillmentLane: .dispatchReady,
                returnStatus: .locked
            )
        ]
    }()
}

enum CommerceFulfillmentLane: Hashable {
    case reviewLocked
    case dispatchReady
    case supportEscalated
    case delivered

    var label: String {
        switch self {
        case .reviewLocked:
            return "Fulfillment review locked"
        case .dispatchReady:
            return "Dispatch lane active"
        case .supportEscalated:
            return "Courier support escalated"
        case .delivered:
            return "Delivery lane closed"
        }
    }
}

enum CommerceReturnStatus: Hashable {
    case locked
    case reviewEligible
    case inspectionPending
    case exchangeApproved
    case closed

    var label: String {
        switch self {
        case .locked:
            return "Return tools locked until delivery"
        case .reviewEligible:
            return "Return inspection can be opened"
        case .inspectionPending:
            return "Return inspection in progress"
        case .exchangeApproved:
            return "Exchange approved"
        case .closed:
            return "Return case closed"
        }
    }
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

extension Double {
    var currencyString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
}
