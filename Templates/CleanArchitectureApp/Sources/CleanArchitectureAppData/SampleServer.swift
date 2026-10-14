import CleanArchitectureAppDomain
import Foundation

/// An in-process stand-in for the backend, so the app runs without network access.
///
/// It answers the same requests as a real server would (see ``UsersAPI``), keeps changes
/// in memory, and can be switched offline to try the cache fallback. Replace it with
/// ``URLSessionHTTPClient`` and your server's base URL to use a real backend.
///
/// Like a real server it checks what it stores: the id in the path must match the body,
/// the role must be one it knows, and an email address may belong to one account only.
/// It does not check who is asking; a real server must enforce the same permissions as
/// the use cases, because a client can always be modified.
public actor SampleServer: HTTPClient {
    /// Requests to this host never leave the process.
    public static let baseURL: URL = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.example.com"
        return components.url ?? URL(filePath: "/")
    }()

    private var records: [UUID: UserDTO]
    private var isReachable = true
    private let latency: Duration

    public init(users: [UserDTO] = SampleServer.seedUsers, latency: Duration = .zero) {
        self.records = Dictionary(uniqueKeysWithValues: users.map { ($0.id, $0) })
        self.latency = latency
    }

    public var reachable: Bool { isReachable }

    public func setReachable(_ reachable: Bool) {
        isReachable = reachable
    }

    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if latency > .zero { try await Task.sleep(for: latency) }
        guard isReachable else { throw URLError(.notConnectedToInternet) }
        guard let url = request.url else { throw URLError(.badURL) }

        let path = url.path().split(separator: "/").map(String.init)
        switch (request.httpMethod ?? "GET", path) {
        case ("GET", ["v1", "users"]):
            let users = records.values.sorted { $0.id.uuidString < $1.id.uuidString }
            return try respond(200, UserListDTO(users: users), to: url)
        case ("PUT", let components) where components.count == 3 && components.starts(with: ["v1", "users"]):
            return try update(id: components[2], body: request.httpBody, url: url)
        default:
            return try respond(404, ErrorDTO(error: "not_found"), to: url)
        }
    }

    private func update(id: String, body: Data?, url: URL) throws -> (Data, HTTPURLResponse) {
        guard let id = UUID(uuidString: id), records[id] != nil else {
            return try respond(404, ErrorDTO(error: "not_found"), to: url)
        }
        guard let body, var user = try? JSONCoding.makeDecoder().decode(UserDTO.self, from: body),
              user.id == id, UserRole(rawValue: user.role) != nil
        else {
            return try respond(400, ErrorDTO(error: "bad_request"), to: url)
        }
        user.email = user.email.lowercased()
        if records.values.contains(where: { $0.id != id && $0.email == user.email }) {
            return try respond(409, ErrorDTO(error: UsersAPI.emailTakenCode), to: url)
        }
        records[id] = user
        return try respond(200, user, to: url)
    }

    private func respond(_ status: Int, _ body: some Encodable, to url: URL) throws -> (Data, HTTPURLResponse) {
        let data = try JSONCoding.makeEncoder().encode(body)
        let headers = ["Content-Type": "application/json"]
        guard let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: "HTTP/1.1", headerFields: headers) else {
            throw URLError(.badServerResponse)
        }
        return (data, response)
    }
}
