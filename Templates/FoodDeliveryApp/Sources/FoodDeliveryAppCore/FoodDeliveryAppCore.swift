import Alamofire
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

    public func makeRestaurantsRequest(baseURL: URL) -> URLRequestConvertible {
        FoodDeliveryEndpoint(baseURL: baseURL, path: "/restaurants")
    }
}

private struct FoodDeliveryEndpoint: URLRequestConvertible, Sendable {
    let baseURL: URL
    let path: String

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}
