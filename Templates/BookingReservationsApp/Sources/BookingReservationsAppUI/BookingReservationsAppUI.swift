import SwiftUI
import BookingReservationsAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct BookingReservationsSummaryCard: View {
    public let snapshot: BookingReservationsDashboardSnapshot
    public let health: BookingOperationsHealth

    public init(
        snapshot: BookingReservationsDashboardSnapshot,
        health: BookingOperationsHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("\(snapshot.checkInsToday) check-ins today", systemImage: "door.left.hand.open")
            Label("\(snapshot.managedProperties) active properties", systemImage: "building.2.fill")
            Label("\(snapshot.pendingRequests) pending requests", systemImage: "calendar.badge.clock")
            Label(snapshot.occupancyHealth, systemImage: "bed.double.fill")
            Label(
                "\(health.averageResponseMinutes) min guest response time",
                systemImage: health.paymentCaptureReady ? "checkmark.circle.fill" : "xmark.circle.fill"
            )
        }
        .padding(.vertical, 8)
    }
}
