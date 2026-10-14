import Foundation
import Testing
@testable import FoodDeliveryApp

@MainActor
@Suite("FoodDeliveryOperationsStore")
struct FoodDeliveryOperationsStoreTests {
    @Test func totalAddsDeliveryAndServiceFeeMinusPromo() {
        let store = FoodDeliveryOperationsStore()
        let subtotal = store.cartItems.reduce(0) { $0 + Double($1.quantity) * $1.unitPrice }

        #expect(store.subtotal == subtotal)
        #expect(abs(store.serviceFee - subtotal * 0.05) < 0.0001)

        store.applyPromo(" dinner6 ")
        #expect(store.appliedPromoCode == "DINNER6")
        #expect(abs(store.total - (subtotal + store.deliveryFee + subtotal * 0.05 - 6)) < 0.0001)
    }

    @Test func unknownPromoClearsAndBlankPromoIsIgnored() {
        let store = FoodDeliveryOperationsStore()
        store.applyPromo("DINNER6")

        store.applyPromo("  ")
        #expect(store.appliedPromoCode == "DINNER6")

        store.applyPromo("FREEFOOD")
        #expect(store.appliedPromoCode.isEmpty)
        #expect(store.promoSavings == 0)
    }

    @Test func totalNeverGoesBelowZero() {
        let store = FoodDeliveryOperationsStore()
        store.cartItems = []
        store.applyPromo("DINNER6")

        #expect(store.deliveryFee < 6)
        #expect(store.total == 0)
    }

    @Test func addingSameMenuItemIncrementsQuantity() {
        let store = FoodDeliveryOperationsStore()
        store.cartItems = []
        let restaurant = store.restaurants[0]
        let item = restaurant.menu[0]

        store.addMenuItem(item, from: restaurant)
        store.addMenuItem(item, from: restaurant)

        #expect(store.cartItems.count == 1)
        #expect(store.cartItems[0].quantity == 2)
    }

    @Test func decrementingToZeroRemovesItem() throws {
        let store = FoodDeliveryOperationsStore()
        let single = try #require(store.cartItems.first { $0.quantity == 1 })

        store.decrementCartItem(single.id)

        #expect(!store.cartItems.contains { $0.id == single.id })
    }

    @Test func placingOrderStartsLiveOrderAndClearsCart() {
        let store = FoodDeliveryOperationsStore()
        store.applyPromo("DINNER6")
        let total = store.total
        let pastCount = store.pastOrders.count

        store.placeOrder()

        #expect(store.liveOrder.status == .confirmed)
        #expect(store.liveOrder.total == total)
        #expect(store.pastOrders.count == pastCount + 1)
        #expect(store.pastOrders[0].id == store.liveOrder.id)
        #expect(store.cartItems.isEmpty)
        #expect(store.appliedPromoCode.isEmpty)
    }

    @Test func emptyCartCannotBeOrdered() {
        let store = FoodDeliveryOperationsStore()
        store.cartItems = []
        let liveOrderID = store.liveOrder.id

        store.placeOrder()

        #expect(store.liveOrder.id == liveOrderID)
    }

    @Test func liveOrderAdvancesThroughEveryStageAndStaysDelivered() {
        let store = FoodDeliveryOperationsStore()
        store.placeOrder()
        var statuses: [DeliveryOrderStatus] = []

        for _ in 0..<5 {
            store.advanceLiveOrder()
            statuses.append(store.liveOrder.status)
        }

        #expect(statuses == [.kitchenPreparing, .courierPickedUp, .courierArriving, .delivered, .delivered])
        #expect(store.liveOrder.progress == 1)
        #expect(store.pastOrders[0].status == .delivered, "past order mirrors the live order")
    }

    @Test func courierRecoveryNeverMovesProgressBackwards() {
        let store = FoodDeliveryOperationsStore()
        store.placeOrder()

        store.reportCourierIssue()
        store.recoverCourierIssue()
        #expect(store.liveOrder.progress == 0.76)

        store.liveOrder.progress = 0.9
        store.recoverCourierIssue()
        #expect(store.liveOrder.progress == 0.9)
    }

    @Test func confirmingDeliveryTwiceAddsOneTimelineEntry() {
        let store = FoodDeliveryOperationsStore()

        store.confirmDelivered()
        store.confirmDelivered()

        #expect(store.liveOrder.timeline.filter { $0 == "Delivered to customer" }.count == 1)
        #expect(store.liveOrder.supportStatus == "Closed")
    }

    @Test func reorderFillsCartFromThatRestaurant() throws {
        let store = FoodDeliveryOperationsStore()
        let order = try #require(store.pastOrders.first { past in store.restaurants.contains { $0.name == past.restaurantName } })
        let restaurant = try #require(store.restaurants.first { $0.name == order.restaurantName })
        store.cartItems = []

        store.reorder(order.id)

        #expect(store.selectedRestaurantID == restaurant.id)
        #expect(store.cartItems.count == min(2, restaurant.menu.count))
    }

    @Test func dashboardHeadlineFollowsOrderAndCartState() {
        let store = FoodDeliveryOperationsStore()
        store.confirmDelivered()
        store.cartItems = []

        #expect(store.dashboardHeadline.hasPrefix("Cart is empty"))
    }
}
