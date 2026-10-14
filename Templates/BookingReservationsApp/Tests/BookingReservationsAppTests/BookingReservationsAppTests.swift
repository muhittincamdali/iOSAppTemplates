import Foundation
import Testing
@testable import BookingReservationsApp

@MainActor
@Suite("BookingOperationsStore")
struct BookingOperationsStoreTests {
    @Test func seedDataSplitsArrivalsAndCheckouts() {
        let store = BookingOperationsStore()

        #expect(store.arrivals.map(\.guestName) == ["Liam Carter", "Mila Harper"])
        #expect(store.checkouts.map(\.guestName) == ["Oliver Reed", "Ava Collins"])
        #expect(store.openRequestCount == 3)
    }

    @Test func verifyingIdentityPromotesAwaitingGuestToReady() {
        let store = BookingOperationsStore()
        let mila = store.stays.first { $0.status == .awaitingID }!

        store.verifyIdentity(for: mila)

        let updated = store.stays.first { $0.id == mila.id }!
        #expect(updated.identityVerified)
        #expect(updated.status == .arrivalReady)
    }

    @Test func verifyingIdentityKeepsOtherStatuses() {
        let store = BookingOperationsStore()
        let inReview = store.stays.first { $0.status == .pendingReview }!

        store.verifyIdentity(for: inReview)

        #expect(store.stays.first { $0.id == inReview.id }?.status == .pendingReview)
    }

    @Test func checkInRemovesGuestFromArrivals() {
        let store = BookingOperationsStore()
        let liam = store.arrivals[0]

        store.checkInGuest(liam)

        #expect(!store.arrivals.contains { $0.id == liam.id })
        #expect(store.stays.first { $0.id == liam.id }?.status == .inHouse)
        #expect(store.operatorHeadline.contains("Liam Carter"))
    }

    @Test func checkoutThenTurnoverReturnsRoomToInventory() {
        let store = BookingOperationsStore()
        let oliver = store.stays.first { $0.status == .checkoutToday }!

        store.completeCheckout(oliver)
        #expect(store.stays.first { $0.id == oliver.id }?.status == .checkedOut)
        #expect(!store.checkouts.contains { $0.id == oliver.id })

        store.confirmTurnover(oliver)
        #expect(store.stays.first { $0.id == oliver.id }?.status == .turnoverReady)
    }

    @Test func settlingReviewMovesStayBackToCheckoutToday() {
        let store = BookingOperationsStore()
        let ava = store.stays.first { $0.status == .pendingReview }!

        store.settlePendingReview(ava)

        #expect(store.stays.first { $0.id == ava.id }?.status == .checkoutToday)
    }

    @Test func approvingLateCheckoutUpdatesTheMatchingStay() {
        let store = BookingOperationsStore()
        let request = store.guestRequests.first { $0.title.contains("Late checkout") }!

        store.approveRequest(request)

        #expect(store.guestRequests.first { $0.id == request.id }?.status == .approved)
        #expect(store.stays.first { $0.guestName == "Ava Collins" }?.note.contains("Late checkout approved") == true)
        #expect(store.openRequestCount == 3, "approved requests still count as open work")
    }

    @Test func resolvingAndEscalatingChangeOpenCount() {
        let store = BookingOperationsStore()

        store.resolveRequest(store.guestRequests[0])
        #expect(store.openRequestCount == 2)

        store.escalateRequest(store.guestRequests[1])
        #expect(store.guestRequests[1].status == .escalated)
        #expect(store.openRequestCount == 2)
    }

    @Test func lockingDayTogglesEachTime() {
        let store = BookingOperationsStore()
        let today = store.calendarDays[0]

        store.lockDay(today)
        #expect(store.calendarDays[0].isLocked)
        store.lockDay(today)
        #expect(!store.calendarDays[0].isLocked)
    }

    @Test func actionsOnUnknownRecordsAreIgnored() {
        let store = BookingOperationsStore()
        let stranger = BookingStayRecord(
            guestName: "Nobody", property: "Nowhere", dateRange: "", status: .awaitingID,
            departureTime: "", note: "", preferences: [], identityVerified: false, checkedIn: false
        )
        let staysBefore = store.stays.map(\.status)
        let headlineBefore = store.operatorHeadline

        store.checkInGuest(stranger)
        store.completeCheckout(stranger)

        #expect(store.stays.map(\.status) == staysBefore)
        #expect(store.operatorHeadline == headlineBefore)
    }
}
