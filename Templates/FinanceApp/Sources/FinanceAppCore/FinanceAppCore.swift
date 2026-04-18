import Alamofire
import Foundation

public struct FinanceDashboardSnapshot: Hashable, Sendable {
    public let accounts: Int
    public let budgetUsage: String
    public let netCash: String
    public let reviewMessage: String

    public init(
        accounts: Int,
        budgetUsage: String,
        netCash: String,
        reviewMessage: String
    ) {
        self.accounts = accounts
        self.budgetUsage = budgetUsage
        self.netCash = netCash
        self.reviewMessage = reviewMessage
    }

    public static let sample = FinanceDashboardSnapshot(
        accounts: 3,
        budgetUsage: "61%",
        netCash: "$8,450",
        reviewMessage: "Travel spend is approaching the monthly limit."
    )
}

public struct FinanceAPIClient: Sendable {
    public init() {}

    public func makeAccountsRequest(baseURL: URL) -> URLRequestConvertible {
        FinanceEndpoint(baseURL: baseURL, path: "/accounts")
    }
}

private struct FinanceEndpoint: URLRequestConvertible, Sendable {
    let baseURL: URL
    let path: String

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}
