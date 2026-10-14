import Foundation
import Testing
@testable import EcommerceApp

@MainActor
@Suite("CommerceStore")
struct CommerceStoreTests {
    @Test func startsWithSeededCartAndDefaultSelections() {
        let store = CommerceStore()

        #expect(store.cartItems.map(\.quantity) == [1, 2])
        #expect(store.wishlistIDs == [store.products[0].id])
        #expect(store.selectedAddress?.id == store.savedAddresses.first?.id)
        #expect(store.selectedPaymentMethod?.id == store.paymentMethods.first?.id)
    }

    @Test func totalsAddShippingBelowThresholdAndTax() throws {
        let store = CommerceStore()
        store.cartItems = []
        let cheapest = try #require(store.products.min(by: { $0.price < $1.price }))
        store.addToCart(cheapest.id)

        #expect(store.subtotal == cheapest.price)
        #expect(store.shippingFee == 12.99)
        #expect(abs(store.taxes - cheapest.price * 0.08) < 0.0001)
        #expect(abs(store.total - (cheapest.price + 12.99 + cheapest.price * 0.08)) < 0.0001)
    }

    @Test func shippingIsFreeFromOneHundredFifty() {
        let store = CommerceStore()
        store.cartItems = []
        let product = store.products[0]
        while store.subtotal < 150 { store.addToCart(product.id) }

        #expect(store.shippingFee == 0)
    }

    @Test func couponIsNormalisedAndOnlyKnownCodeApplies() {
        let store = CommerceStore()

        store.applyCoupon("  sprint10 ")
        #expect(store.appliedCouponCode == "SPRINT10")
        #expect(abs(store.savings - store.subtotal * 0.1) < 0.0001)

        store.applyCoupon("   ")
        #expect(store.appliedCouponCode == "SPRINT10", "blank input keeps the current coupon")

        store.applyCoupon("FREESTUFF")
        #expect(store.appliedCouponCode.isEmpty)
        #expect(store.savings == 0)
    }

    @Test func addingSameProductIncrementsQuantityAndUnknownIDIsIgnored() {
        let store = CommerceStore()
        store.cartItems = []
        let product = store.products[0]

        store.addToCart(product.id)
        store.addToCart(product.id)
        store.addToCart(UUID())

        #expect(store.cartItems.count == 1)
        #expect(store.cartItems[0].quantity == 2)
    }

    @Test func decrementingLastUnitRemovesItem() throws {
        let store = CommerceStore()
        let single = try #require(store.cartItems.first { $0.quantity == 1 })

        store.decrementCartItem(single.id)

        #expect(!store.cartItems.contains { $0.id == single.id })
    }

    @Test func togglingWishlistTwiceRestoresState() {
        let store = CommerceStore()
        let product = store.products[1]

        store.toggleWishlist(product.id)
        #expect(store.wishlistIDs.contains(product.id))
        store.toggleWishlist(product.id)
        #expect(!store.wishlistIDs.contains(product.id))
    }

    @Test func selectingCategoryFiltersProducts() {
        let store = CommerceStore()
        let category = store.categories[1]

        store.selectCategory(category.id)

        #expect(!store.visibleProducts.isEmpty)
        #expect(store.visibleProducts.allSatisfy { $0.categoryID == category.id })
    }

    @Test func placingOrderMovesCartIntoNewOrder() {
        let store = CommerceStore()
        store.applyCoupon("SPRINT10")
        let expectedTotal = store.total
        let orderCount = store.placedOrders.count

        store.placeOrder()

        #expect(store.placedOrders.count == orderCount + 1)
        #expect(store.placedOrders[0].total == expectedTotal)
        #expect(store.placedOrders[0].fulfillmentLane == .dispatchReady)
        #expect(store.cartItems.isEmpty)
        #expect(store.appliedCouponCode.isEmpty)
    }

    @Test func placingOrderWithEmptyCartDoesNothing() {
        let store = CommerceStore()
        store.cartItems = []
        let orderCount = store.placedOrders.count

        store.placeOrder()

        #expect(store.placedOrders.count == orderCount)
    }

    @Test func fulfillmentReviewBlocksDispatchUntilCleared() throws {
        let store = CommerceStore()
        store.placeOrder()
        let orderID = store.placedOrders[0].id
        let timelineBefore = store.placedOrders[0].timeline.map(\.state)

        store.lockFulfillmentReview(orderID)
        store.advanceOrder(orderID)
        #expect(store.placedOrders[0].fulfillmentLane == .reviewLocked)
        #expect(store.placedOrders[0].timeline.map(\.state) == timelineBefore)

        store.clearFulfillmentReview(orderID)
        store.advanceOrder(orderID)
        #expect(store.placedOrders[0].statusHeadline == "Delivered")
        #expect(store.placedOrders[0].timeline.allSatisfy { $0.state != .pending })
    }

    @Test func returnFlowRequiresEachStepInOrder() {
        let store = CommerceStore()
        store.placeOrder()
        let orderID = store.placedOrders[0].id

        store.approveExchange(orderID)
        store.openReturnInspection(orderID)
        #expect(store.placedOrders[0].returnStatus == .locked, "returns stay locked before delivery")

        store.confirmDelivery(orderID)
        #expect(store.placedOrders[0].returnStatus == .reviewEligible)
        #expect(store.placedOrders[0].fulfillmentLane == .delivered)

        store.closeReturnCase(orderID)
        #expect(store.placedOrders[0].returnStatus == .reviewEligible, "cannot close before an exchange")

        store.openReturnInspection(orderID)
        store.approveExchange(orderID)
        store.closeReturnCase(orderID)
        #expect(store.placedOrders[0].returnStatus == .closed)
        #expect(store.activeReturnCaseCount == 0)
    }

    @Test func supportIssueEscalatesAndResolvesToPreviousLane() {
        let store = CommerceStore()
        store.placeOrder()
        let orderID = store.placedOrders[0].id

        store.openSupportIssue(orderID)
        #expect(store.activeSupportCaseCount >= 1)
        #expect(store.placedOrders[0].fulfillmentLane == .supportEscalated)

        store.resolveSupportIssue(orderID)
        #expect(store.placedOrders[0].fulfillmentLane == .dispatchReady)
    }

    @Test func reorderCopiesOrderItemsIntoCart() {
        let store = CommerceStore()
        let order = store.placedOrders[0]
        store.cartItems = []

        store.reorder(order.id)

        #expect(store.cartItems == order.items)
    }
}
