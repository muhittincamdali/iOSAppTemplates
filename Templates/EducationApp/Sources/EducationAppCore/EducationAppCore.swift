import Foundation

public struct EducationDashboardSnapshot: Hashable, Sendable {
    public let activeCourses: Int
    public let completionRate: String
    public let nextMilestone: String
    public let coachMessage: String

    public init(
        activeCourses: Int,
        completionRate: String,
        nextMilestone: String,
        coachMessage: String
    ) {
        self.activeCourses = activeCourses
        self.completionRate = completionRate
        self.nextMilestone = nextMilestone
        self.coachMessage = coachMessage
    }

    public static let sample = EducationDashboardSnapshot(
        activeCourses: 3,
        completionRate: "74%",
        nextMilestone: "Quiz 4 due tomorrow",
        coachMessage: "Your design systems course is ready for the next lesson."
    )
}

public struct EducationAPIClient: Sendable {
    public init() {}

    /// Builds the GET request for the `/courses` resource relative to `baseURL`.
    public func makeCoursesRequest(baseURL: URL) -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("courses"))
        request.httpMethod = "GET"
        return request
    }
}
