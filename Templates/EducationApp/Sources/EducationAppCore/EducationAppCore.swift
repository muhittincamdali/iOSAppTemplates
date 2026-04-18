import Alamofire
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

    public func makeCoursesRequest(baseURL: URL) -> URLRequestConvertible {
        EducationEndpoint(baseURL: baseURL, path: "/courses")
    }
}

private struct EducationEndpoint: URLRequestConvertible, Sendable {
    let baseURL: URL
    let path: String

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        return request
    }
}
