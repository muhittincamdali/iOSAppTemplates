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

    @Test func verifyingIdentityPromotesAwaitingGuestToReady() throws {
        let store = BookingOperationsStore()
        let mila = try #require(store.stays.first { $0.status == .awaitingID })

        store.verifyIdentity(for: mila)

        let updated = try #require(store.stays.first { $0.id == mila.id })
        #expect(updated.identityVerified)
        #expect(updated.status == .arrivalReady)
    }

    @Test func verifyingIdentityKeepsOtherStatuses() throws {
        let store = BookingOperationsStore()
        let inReview = try #require(store.stays.first { $0.status == .pendingReview })

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

    @Test func checkoutThenTurnoverReturnsRoomToInventory() throws {
        let store = BookingOperationsStore()
        let oliver = try #require(store.stays.first { $0.status == .checkoutToday })

        store.completeCheckout(oliver)
        #expect(store.stays.first { $0.id == oliver.id }?.status == .checkedOut)
        #expect(!store.checkouts.contains { $0.id == oliver.id })

        store.confirmTurnover(oliver)
        #expect(store.stays.first { $0.id == oliver.id }?.status == .turnoverReady)
    }

    @Test func settlingReviewMovesStayBackToCheckoutToday() throws {
        let store = BookingOperationsStore()
        let ava = try #require(store.stays.first { $0.status == .pendingReview })

        store.settlePendingReview(ava)

        #expect(store.stays.first { $0.id == ava.id }?.status == .checkoutToday)
    }

    @Test func approvingLateCheckoutUpdatesTheMatchingStay() throws {
        let store = BookingOperationsStore()
        let request = try #require(store.guestRequests.first { $0.title.contains("Late checkout") })

        store.approveRequest(request)

        #expect(store.guestRequests.first { $0.id == request.id }?.status == .approved)
        #expect(store.stays.first { $0.guestName == "Ava Collins" }?.note.contains("Late checkout approved") == true)
        #expect(store.openRequestCount == 3, "approved requests still count as open work")
    }

    @Test func approvingARequestChangesOnlyTheLinkedStay() throws {
        let store = BookingOperationsStore()
        let request = try #require(store.guestRequests.first { $0.title.contains("Airport transfer") })
        let linkedStay = try #require(store.stays.first { $0.id == request.stayID })
        let otherNotes = store.stays.filter { $0.id != linkedStay.id }.map(\.note)

        store.approveRequest(request)

        #expect(store.stays.first { $0.id == linkedStay.id }?.note == request.approvalNote)
        #expect(store.stays.filter { $0.id != linkedStay.id }.map(\.note) == otherNotes)
    }

    @Test func approvingARequestWithoutAStayLeavesStaysUnchanged() {
        let store = BookingOperationsStore()
        let notesBefore = store.stays.map(\.note)
        let walkIn = BookingRequestRecord(
            title: "Walk-in upgrade",
            guest: "Walk-in guest",
            stayID: nil,
            priority: .medium,
            nextAction: "Check suite availability.",
            approvalNote: "Upgrade approved.",
            status: .open
        )
        store.guestRequests.append(walkIn)

        store.approveRequest(walkIn)

        #expect(store.guestRequests.last?.status == .approved)
        #expect(store.stays.map(\.note) == notesBefore)
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
