import Foundation

struct TravelPlannerFlowExample {
    let destination: String
    let itineraryStatus: String
    let nextAction: String
}

let travelPlannerExample = TravelPlannerFlowExample(
    destination: "Tokyo",
    itineraryStatus: "All bookings confirmed",
    nextAction: "Open itinerary review"
)
