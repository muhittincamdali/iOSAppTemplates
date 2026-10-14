import Foundation
import Testing
@testable import TravelPlannerApp

@MainActor
@Suite("TravelPlannerOperationsStore")
struct TravelPlannerOperationsStoreTests {
    @Test func seededReadinessReflectsOpenAlerts() {
        let store = TravelPlannerOperationsStore()

        #expect(store.unresolvedAlerts == 2)
        #expect(store.readinessHeadline.hasPrefix("2 trip alerts"))
    }

    @Test func checkInAssignsDefaultSeatAndClearsCheckInAlert() throws {
        let store = TravelPlannerOperationsStore()
        let flight = try #require(store.flights.first { !$0.isCheckedIn })

        store.confirmCheckIn(flight.id)

        let updated = try #require(store.flights.first { $0.id == flight.id })
        #expect(updated.isCheckedIn)
        #expect(updated.seat == "12A")
        #expect(!store.alerts.contains { $0.linkedFlightID == flight.id && $0.type == .checkIn })
        #expect(store.unresolvedAlerts == 1)
    }

    @Test func checkInKeepsAnExistingSeat() throws {
        let store = TravelPlannerOperationsStore()
        let seated = try #require(store.flights.first { $0.seat != nil })

        store.confirmCheckIn(seated.id)

        #expect(store.flights.first { $0.id == seated.id }?.seat == seated.seat)
    }

    @Test func rebookRequestOpensAlertAndConfirmationRecoversIt() {
        let store = TravelPlannerOperationsStore()
        let flight = store.flights[1]
        let recovered = store.incidentRecoveredCount

        store.requestRebook(flight.id)
        #expect(store.alerts.last?.type == .disruption)
        #expect(store.alerts.last?.linkedFlightID == flight.id)

        store.confirmRebook(flight.id)
        #expect(store.flights[1].status == "Rebooked")
        #expect(store.flights[1].departureTime.hasSuffix("+45 min buffer"))
        #expect(store.incidentRecoveredCount == recovered + 1)
    }

    @Test func readyDocumentsRemoveLinkedAlertsAndHeadlineTurnsGreen() {
        let store = TravelPlannerOperationsStore()
        for flight in store.flights { store.confirmCheckIn(flight.id) }
        #expect(store.readinessHeadline.hasPrefix("1 trip alerts"))

        for document in store.documents { store.markDocumentReady(document.id) }

        #expect(store.unresolvedAlerts == 0)
        #expect(store.verifiedDocuments == store.documents.count)
        #expect(store.readinessHeadline == "Trip operations are aligned for departure.")
    }

    @Test func movingActivityShiftsItToTheNextDay() throws {
        let store = TravelPlannerOperationsStore()
        let day = try #require(store.timelineDays.first { !$0.activities.isEmpty })
        let dayIndex = try #require(store.timelineDays.firstIndex { $0.id == day.id })
        try #require(dayIndex + 1 < store.timelineDays.count)
        let activity = day.activities[0]

        store.moveActivityForward(activity.id, from: day.id)

        #expect(!store.timelineDays[dayIndex].activities.contains { $0.id == activity.id })
        #expect(store.timelineDays[dayIndex + 1].activities.first?.id == activity.id)
    }

    @Test func lastDayActivitiesCannotMoveForward() {
        let store = TravelPlannerOperationsStore()
        let lastIndex = store.timelineDays.count - 1
        let lastDay = store.timelineDays[lastIndex]
        guard let activity = lastDay.activities.first else { return }

        store.moveActivityForward(activity.id, from: lastDay.id)

        #expect(store.timelineDays[lastIndex].activities.map(\.id) == lastDay.activities.map(\.id))
    }

    @Test func dayPlanLockToggle() {
        let store = TravelPlannerOperationsStore()
        let day = store.timelineDays[0]

        store.lockDayPlan(day.id)
        #expect(store.timelineDays[0].isLocked)
        store.unlockDayPlan(day.id)
        #expect(!store.timelineDays[0].isLocked)
    }

    @Test func packingAndRescuePackCounters() throws {
        let store = TravelPlannerOperationsStore()
        let task = try #require(store.packingTasks.first { !$0.isPacked })
        let packed = store.packedTasks
        let rescue = store.rescuePackCount

        let document = try #require(store.documents.first { !$0.rescuePackIncluded })
        store.togglePackingTask(task.id)
        store.createRescuePack(document.id)

        #expect(store.packedTasks == packed + 1)
        #expect(store.rescuePackCount == rescue + 1)
    }

    @Test func escalationKeepsAlertOpenUntilCleared() {
        let store = TravelPlannerOperationsStore()
        let alert = store.alerts[0]

        store.escalateAlert(alert.id)
        #expect(store.alerts[0].incidentState == "Escalated")
        #expect(!store.alerts[0].isResolved)

        store.clearIncident(alert.id)
        #expect(store.alerts[0].isResolved)
        #expect(store.alerts[0].incidentState == "Recovered")
    }
}
