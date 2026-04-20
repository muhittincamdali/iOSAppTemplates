import SwiftUI
import BookingReservationsAppCore
import BookingReservationsAppUI

@available(iOS 18.0, macOS 15.0, *)
public struct BookingReservationsAppShell: App {
    public init() {}

    public var body: some Scene {
        WindowGroup {
            BookingReservationsDashboardView(
                snapshot: .sample,
                properties: BookingPropertyCard.sampleCards,
                actions: BookingReservationsQuickAction.defaultActions,
                health: .sample
            )
        }
    }
}

@available(iOS 18.0, macOS 15.0, *)
public struct BookingReservationsDashboardView: View {
    public let snapshot: BookingReservationsDashboardSnapshot
    public let properties: [BookingPropertyCard]
    public let actions: [BookingReservationsQuickAction]
    public let health: BookingOperationsHealth

    public init(
        snapshot: BookingReservationsDashboardSnapshot,
        properties: [BookingPropertyCard],
        actions: [BookingReservationsQuickAction],
        health: BookingOperationsHealth
    ) {
        self.snapshot = snapshot
        self.properties = properties
        self.actions = actions
        self.health = health
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("Reservations Overview") {
                    BookingReservationsSummaryCard(
                        snapshot: snapshot,
                        health: health
                    )
                }

                Section("Property Lanes") {
                    ForEach(properties) { property in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(property.title)
                            Text("\(property.reservationCount) reservations")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(property.ctaLabel)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Quick Actions") {
                    ForEach(actions) { action in
                        Label(action.title, systemImage: action.systemImage)
                    }
                }
            }
            .navigationTitle("BookingReservationsApp")
        }
    }
}

public struct BookingReservationsQuickAction: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let systemImage: String

    public init(
        id: UUID = UUID(),
        title: String,
        systemImage: String
    ) {
        self.id = id
        self.title = title
        self.systemImage = systemImage
    }

    public static let defaultActions: [BookingReservationsQuickAction] = [
        BookingReservationsQuickAction(title: "Open Arrival Board", systemImage: "calendar"),
        BookingReservationsQuickAction(title: "Review Guest Requests", systemImage: "message.badge.fill"),
        BookingReservationsQuickAction(title: "Inspect Occupancy Pulse", systemImage: "waveform.path.ecg")
    ]
}
