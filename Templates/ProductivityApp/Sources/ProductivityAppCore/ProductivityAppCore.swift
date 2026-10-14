import Foundation

public struct ProductivityWorkspaceSummary: Hashable, Sendable {
    public let openTasks: Int
    public let activeProjects: Int
    public let focusMinutes: Int
    public let upcomingDeadline: String

    public init(
        openTasks: Int,
        activeProjects: Int,
        focusMinutes: Int,
        upcomingDeadline: String
    ) {
        self.openTasks = openTasks
        self.activeProjects = activeProjects
        self.focusMinutes = focusMinutes
        self.upcomingDeadline = upcomingDeadline
    }

    public static let sample = ProductivityWorkspaceSummary(
        openTasks: 12,
        activeProjects: 4,
        focusMinutes: 90,
        upcomingDeadline: "Launch review at 16:00"
    )
}

public struct ProductivityAPIClient: Sendable {
    public init() {}

    /// Builds the GET request for the `/tasks` resource relative to `baseURL`.
    public func makeTasksRequest(baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("tasks"))
        request.httpMethod = "GET"
        return request
    }
}
