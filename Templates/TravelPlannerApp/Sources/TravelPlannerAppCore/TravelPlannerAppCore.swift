import Foundation
import Alamofire

public struct TravelPlannerDashboardSnapshot: Hashable, Sendable {
    public let activeTrips: Int
    public let nextDestination: String
    public let upcomingFlight: String
    public let itineraryStatus: String

    public init(
        activeTrips: Int,
        nextDestination: String,
        upcomingFlight: String,
        itineraryStatus: String
    ) {
        self.activeTrips = activeTrips
        self.nextDestination = nextDestination
        self.upcomingFlight = upcomingFlight
        self.itineraryStatus = itineraryStatus
    }

    public static let sample = TravelPlannerDashboardSnapshot(
        activeTrips: 2,
        nextDestination: "Tokyo",
        upcomingFlight: "TK 1983 • 08:45",
        itineraryStatus: "All bookings confirmed"
    )
}

public struct TravelPlannerItineraryCard: Identifiable, Hashable, Sendable {
    public let id: UUID
    public let title: String
    public let timeLabel: String
    public let status: String

    public init(
        id: UUID = UUID(),
        title: String,
        timeLabel: String,
        status: String
    ) {
        self.id = id
        self.title = title
        self.timeLabel = timeLabel
        self.status = status
    }

    public static let sampleCards: [TravelPlannerItineraryCard] = [
        TravelPlannerItineraryCard(
            title: "Airport transfer",
            timeLabel: "07:15",
            status: "Driver assigned"
        ),
        TravelPlannerItineraryCard(
            title: "Hotel check-in",
            timeLabel: "14:00",
            status: "Priority room ready"
        ),
        TravelPlannerItineraryCard(
            title: "Shibuya food tour",
            timeLabel: "18:30",
            status: "Booked"
        )
    ]
}

public struct TravelPlannerBookingHealth: Hashable, Sendable {
    public let flightsConfirmed: Int
    public let hotelsConfirmed: Int
    public let alerts: Int

    public init(
        flightsConfirmed: Int,
        hotelsConfirmed: Int,
        alerts: Int
    ) {
        self.flightsConfirmed = flightsConfirmed
        self.hotelsConfirmed = hotelsConfirmed
        self.alerts = alerts
    }

    public static let sample = TravelPlannerBookingHealth(
        flightsConfirmed: 2,
        hotelsConfirmed: 1,
        alerts: 0
    )
}
