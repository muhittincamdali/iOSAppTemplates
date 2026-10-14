import Foundation
import SwiftUI

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

    static let freeShippingThreshold: Double = 150
    static let standardShippingFee = 12.99

    /// Shipping is free once the subtotal reaches the threshold, before coupon savings.
    static func shippingFee(forSubtotal subtotal: Double) -> Double {
        subtotal >= freeShippingThreshold ? 0 : standardShippingFee
    }

    var shippingFee: Double {
        Self.shippingFee(forSubtotal: subtotal)
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

    var reviewLockedOrdersCount: Int {
        placedOrders.filter { $0.fulfillmentLane == .reviewLocked }.count
    }

    var activeSupportCaseCount: Int {
        placedOrders.filter { $0.fulfillmentLane == .supportEscalated }.count
    }

    var activeReturnCaseCount: Int {
        placedOrders.filter { $0.returnStatus == .inspectionPending || $0.returnStatus == .exchangeApproved }.count
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
            supportStatus: "Healthy",
            fulfillmentLane: .dispatchReady,
            returnStatus: .locked
        )

        placedOrders.insert(order, at: 0)
        cartItems.removeAll()
        appliedCouponCode = ""
        checkoutNotice = "Order locked into \(selectedDeliveryWindow). Dispatch stays green unless fulfillment review or courier support opens."
    }

    func reorder(_ orderID: UUID) {
        guard let order = placedOrders.first(where: { $0.id == orderID }) else { return }
        cartItems = order.items
    }

    func advanceOrder(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        guard placedOrders[index].fulfillmentLane != .reviewLocked else {
            checkoutNotice = "Fulfillment review is holding \(placedOrders[index].title). Clear the review before dispatch can advance."
            return
        }

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

        placedOrders[index].fulfillmentLane = placedOrders[index].statusHeadline == "Delivered" ? .delivered : .dispatchReady
    }

    func confirmDelivery(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        for timelineIndex in placedOrders[index].timeline.indices {
            placedOrders[index].timeline[timelineIndex].state = .completed
        }
        placedOrders[index].statusHeadline = "Delivered"
        placedOrders[index].shipmentETA = "Delivered now"
        placedOrders[index].supportStatus = "Post-purchase window active"
        placedOrders[index].fulfillmentLane = .delivered
        placedOrders[index].returnStatus = .reviewEligible
        checkoutNotice = "\(placedOrders[index].title) delivered. Return inspection and exchange tools are now unlocked."
    }

    func lockFulfillmentReview(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        guard placedOrders[index].statusHeadline != "Delivered" else { return }
        placedOrders[index].fulfillmentLane = .reviewLocked
        placedOrders[index].supportStatus = "Fulfillment review active"
        checkoutNotice = "Fulfillment review opened for \(placedOrders[index].title). Dispatch is paused until the review clears."
    }

    func clearFulfillmentReview(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        guard placedOrders[index].fulfillmentLane == .reviewLocked else { return }
        placedOrders[index].fulfillmentLane = .dispatchReady
        placedOrders[index].supportStatus = "Review cleared"
        checkoutNotice = "Fulfillment review cleared for \(placedOrders[index].title). Dispatch lane is live again."
    }

    func openSupportIssue(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        placedOrders[index].supportStatus = "Courier issue opened"
        placedOrders[index].supportAction = "Resolve courier issue"
        placedOrders[index].fulfillmentLane = .supportEscalated
        checkoutNotice = "Support case opened for \(placedOrders[index].title)."
    }

    func resolveSupportIssue(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        placedOrders[index].supportStatus = "Support resolved"
        placedOrders[index].supportAction = "Reorder Items"
        if placedOrders[index].statusHeadline == "Delivered" {
            placedOrders[index].fulfillmentLane = .delivered
        } else {
            placedOrders[index].fulfillmentLane = .dispatchReady
        }
        checkoutNotice = "Support issue resolved and post-purchase state is healthy again."
    }

    func openReturnInspection(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        guard placedOrders[index].returnStatus == .reviewEligible else { return }
        placedOrders[index].returnStatus = .inspectionPending
        placedOrders[index].supportStatus = "Return inspection active"
        checkoutNotice = "Return inspection opened for \(placedOrders[index].title). Buyer proof, packaging, and delivery trace are under review."
    }

    func approveExchange(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        guard placedOrders[index].returnStatus == .inspectionPending else { return }
        placedOrders[index].returnStatus = .exchangeApproved
        placedOrders[index].statusHeadline = "Replacement queued"
        placedOrders[index].shipmentETA = "Replacement ships tomorrow"
        placedOrders[index].supportStatus = "Exchange approved"
        checkoutNotice = "Exchange approved for \(placedOrders[index].title). Replacement fulfillment lane is now active."
    }

    func closeReturnCase(_ orderID: UUID) {
        guard let index = placedOrders.firstIndex(where: { $0.id == orderID }) else { return }
        guard placedOrders[index].returnStatus == .exchangeApproved else { return }
        placedOrders[index].returnStatus = .closed
        placedOrders[index].supportStatus = "Return case closed"
        checkoutNotice = "Return case closed for \(placedOrders[index].title). Buyer can reorder or keep the replacement lane."
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
