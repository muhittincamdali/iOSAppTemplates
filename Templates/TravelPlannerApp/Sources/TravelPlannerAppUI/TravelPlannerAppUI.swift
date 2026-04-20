import SwiftUI
import TravelPlannerAppCore

@available(iOS 18.0, macOS 15.0, *)
public struct TravelPlannerSummaryCard: View {
    public let snapshot: TravelPlannerDashboardSnapshot
    public let health: TravelPlannerBookingHealth

    public init(
        snapshot: TravelPlannerDashboardSnapshot,
        health: TravelPlannerBookingHealth
    ) {
        self.snapshot = snapshot
        self.health = health
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(snapshot.nextDestination)
                .font(.title2.bold())

            LabeledContent("Upcoming Flight", value: snapshot.upcomingFlight)
            LabeledContent("Trip Status", value: snapshot.itineraryStatus)
            LabeledContent("Confirmed Flights", value: "\(health.flightsConfirmed)")
            LabeledContent("Confirmed Hotels", value: "\(health.hotelsConfirmed)")
        }
    }
}
