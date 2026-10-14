import Foundation
import Testing
@testable import MarketplaceApp

@MainActor
@Suite("MarketplaceOperationsStore")
struct MarketplaceOperationsStoreTests {
    private func listing(_ title: String, in store: MarketplaceOperationsStore) -> MarketplaceListingRecord {
        store.listings.first { $0.title == title }!
    }

    @Test func seededCountersMatchSampleData() {
        let store = MarketplaceOperationsStore()

        #expect(store.subtotal == 389)
        #expect(store.heldPayoutCount == 1)
        #expect(store.trustExposureCount == 2)
        #expect(store.featuredListings.map(\.title) == ["Mirrorless Creator Camera", "Portable Smart Projector"])
    }

    @Test func categorySelectionFiltersListings() {
        let store = MarketplaceOperationsStore()

        store.selectCategory("Home Studio")

        #expect(store.featuredListings.map(\.title) == ["Home Podcast Mixer"])
    }

    @Test func reservingExistingCartListingIncrementsQuantityAndStock() {
        let store = MarketplaceOperationsStore()
        let mixer = listing("Home Podcast Mixer", in: store)

        store.reserveListing(mixer)

        #expect(store.cart.count == 1)
        #expect(store.cart[0].quantity == 2)
        #expect(listing("Home Podcast Mixer", in: store).stockCount == mixer.stockCount - 1)
        #expect(listing("Home Podcast Mixer", in: store).isReserved)
        #expect(store.subtotal == 778)
    }

    @Test func soldOutListingCannotBeReserved() {
        let store = MarketplaceOperationsStore()
        let index = store.listings.firstIndex { $0.title == "Refurbished Ultrabook" }!
        store.listings[index].stockCount = 0

        store.reserveListing(store.listings[index])

        #expect(!store.cart.contains { $0.listingTitle == "Refurbished Ultrabook" })
    }

    @Test func decrementingSingleItemRemovesIt() {
        let store = MarketplaceOperationsStore()

        store.decrementCart(store.cart[0])

        #expect(store.cart.isEmpty)
        #expect(store.subtotal == 0)
    }

    @Test func placingOrderUsesFirstCartItemAndEmptiesCart() {
        let store = MarketplaceOperationsStore()
        store.incrementCart(store.cart[0])
        let orders = store.orders.count

        store.placeReservedOrder()

        #expect(store.orders.count == orders + 1)
        #expect(store.orders[0].status == .processing)
        #expect(store.orders[0].total == 778)
        #expect(store.cart.isEmpty)
    }

    @Test func emptyCartPlacesNoOrder() {
        let store = MarketplaceOperationsStore()
        store.cart = []
        let orders = store.orders.count

        store.placeReservedOrder()

        #expect(store.orders.count == orders)
    }

    @Test func orderAdvancesToDeliveredAndStops() {
        let store = MarketplaceOperationsStore()
        store.placeReservedOrder()
        let order = store.orders[0]

        for _ in 0..<5 { store.advanceOrder(order) }

        #expect(store.orders[0].status == .delivered)
    }

    @Test func manualReviewBlocksAdvanceUntilCleared() {
        let store = MarketplaceOperationsStore()
        let reviewed = store.orders.first { $0.status == .manualReview }!

        store.advanceOrder(reviewed)
        #expect(store.orders.first { $0.id == reviewed.id }?.status == .manualReview)

        store.clearManualReview(reviewed)
        store.advanceOrder(reviewed)
        #expect(store.orders.first { $0.id == reviewed.id }?.status == .packed)
    }

    @Test func buyerProtectionHoldsSellerPayoutsAndOpensDispute() {
        let store = MarketplaceOperationsStore()
        let order = store.orders.first { $0.seller == "North Studio" }!
        let disputes = store.disputes.count

        store.requestBuyerProtection(order)

        #expect(store.orders.first { $0.id == order.id }?.status == .manualReview)
        #expect(store.payouts.filter { $0.seller == "North Studio" }.allSatisfy { $0.isHeld })
        #expect(store.disputes.count == disputes + 1)
        #expect(store.trustExposureCount == 3)
    }

    @Test func resolvingDisputeReleasesOneHeldPayout() {
        let store = MarketplaceOperationsStore()

        store.resolveDispute(store.disputes[0])

        #expect(store.disputes[0].status == .resolved)
        #expect(store.heldPayoutCount == 0)
        #expect(store.trustExposureCount == 1)
    }

    @Test func escalatingDisputeBlocksRelatedSellerQueueItem() {
        let store = MarketplaceOperationsStore()

        store.escalateDispute(store.disputes[1])

        #expect(store.disputes[1].status == .escalated)
        #expect(store.sellerQueue.first { $0.title.contains("Renew Point") }?.status == .blocked)
    }

    @Test func payoutHoldAndReleaseRoundTrip() {
        let store = MarketplaceOperationsStore()
        let payout = store.payouts[0]

        store.holdPayout(payout)
        #expect(store.heldPayoutCount == 2)
        store.releasePayout(payout)
        #expect(store.heldPayoutCount == 1)
    }
}
