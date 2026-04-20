import Foundation

public struct BookingReservationsDashboardSnapshot: Hashable, Sendable {
    public let checkInsToday: Int
    public let managedProperties: Int
    public let pendingRequests: Int
    public let occupancyHealth: String

    public init(
        checkInsToday: Int,
        managedProperties: Int,
        pendingRequests: Int,
        occupancyHealth: String
    ) {
        self.checkInsToday = checkInsToday
        self.managedProperties = managedProperties
        self.pendingRequests = pendingRequests
        self.occupancyHealth = occupancyHealth
    }

    public static let sample = BookingReservationsDashboardSnapshot(
        checkInsToday: 42,
        managedProperties: 18,
        pendingRequests: 7,
        occupancyHealth: "Weekend occupancy on target"
    )
}

public struct BookingPropertyCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let reservationCount: Int
    public let ctaLabel: String

    public init(
        id: UUID = UUID(),
        title: String,
        reservationCount: Int,
        ctaLabel: String
    ) {
        self.id = id
        self.title = title
        self.reservationCount = reservationCount
        self.ctaLabel = ctaLabel
    }

    public static let sampleCards: [BookingPropertyCard] = [
        BookingPropertyCard(title: "City Loft", reservationCount: 11, ctaLabel: "Open arrival board"),
        BookingPropertyCard(title: "Coastal Retreat", reservationCount: 8, ctaLabel: "Review requests"),
        BookingPropertyCard(title: "Business Suites", reservationCount: 15, ctaLabel: "Inspect occupancy")
    ]
}

public struct BookingOperationsHealth: Hashable, Sendable {
    public let supportEscalations: Int
    public let averageResponseMinutes: Int
    public let paymentCaptureReady: Bool

    public init(
        supportEscalations: Int,
        averageResponseMinutes: Int,
        paymentCaptureReady: Bool
    ) {
        self.supportEscalations = supportEscalations
        self.averageResponseMinutes = averageResponseMinutes
        self.paymentCaptureReady = paymentCaptureReady
    }

    public static let sample = BookingOperationsHealth(
        supportEscalations: 3,
        averageResponseMinutes: 12,
        paymentCaptureReady: true
    )
}
