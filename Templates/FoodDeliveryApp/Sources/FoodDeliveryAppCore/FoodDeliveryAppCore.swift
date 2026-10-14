import Foundation

public struct FoodDeliveryDashboardSnapshot: Hashable, Sendable {
    public let restaurants: Int
    public let averageETA: String
    public let liveOrderStatus: String
    public let featuredCuisine: String

    public init(
        restaurants: Int,
        averageETA: String,
        liveOrderStatus: String,
        featuredCuisine: String
    ) {
        self.restaurants = restaurants
        self.averageETA = averageETA
        self.liveOrderStatus = liveOrderStatus
        self.featuredCuisine = featuredCuisine
    }

    public static let sample = FoodDeliveryDashboardSnapshot(
        restaurants: 18,
        averageETA: "24 min",
        liveOrderStatus: "Courier arriving in 8 min",
        featuredCuisine: "Mediterranean"
    )
}

public struct FoodDeliveryAPIClient: Sendable {
    public init() {}

    /// Builds the GET request for the `/restaurants` resource relative to `baseURL`.
    public func makeRestaurantsRequest(baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("restaurants"))
        request.httpMethod = "GET"
        return request
    }
}
