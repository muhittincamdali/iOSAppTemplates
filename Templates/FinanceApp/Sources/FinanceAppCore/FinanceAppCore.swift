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

    /// Builds the GET request for the `/accounts` resource relative to `baseURL`.
    public func makeAccountsRequest(baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("accounts"))
        request.httpMethod = "GET"
        return request
    }
}
