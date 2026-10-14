@testable import CleanArchitectureAppData
import CleanArchitectureAppDomain
import Foundation
import Testing

/// Answers every request with the same response or error, and records the requests.
actor StubHTTPClient: HTTPClient {
    enum Reply {
        case response(status: Int, body: String)
        case failure(any Error)
    }

    private let reply: Reply
    private(set) var requests: [URLRequest] = []

    init(_ reply: Reply) {
        self.reply = reply
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        requests.append(request)
        switch reply {
        case let .response(status, body):
            let url = request.url ?? SampleServer.baseURL
            guard let response = HTTPURLResponse(url: url, statusCode: status, httpVersion: nil, headerFields: nil) else {
                throw URLError(.badServerResponse)
            }
            return (Data(body.utf8), response)
        case .failure(let error):
            throw error
        }
    }
}

let sampleUserJSON = """
{"id":"00000000-0000-0000-0000-000000000001","full_name":"Ada Lovelace","email":"ada@example.com",\
"role":"admin","is_active":true,"joined_at":"2023-01-09T09:00:00Z"}
"""

@Suite("UsersAPI")
struct UsersAPITests {
    private func api(_ reply: StubHTTPClient.Reply) -> (UsersAPI, StubHTTPClient) {
        let client = StubHTTPClient(reply)
        return (UsersAPI(baseURL: SampleServer.baseURL, client: client), client)
    }

    @Test func decodesSnakeCaseKeysAndISODates() async throws {
        let (api, client) = api(.response(status: 200, body: #"{"users":[\#(sampleUserJSON)]}"#))
        let users = try await api.fetchUsers()
        #expect(users.count == 1)
        #expect(users[0].fullName == "Ada Lovelace")
        #expect(users[0].isActive)
        #expect(users[0].joinedAt == Date(timeIntervalSince1970: 1_673_254_800))
        let request = try #require(await client.requests.first)
        #expect(request.url?.absoluteString == "https://api.example.com/v1/users")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test func updateSendsAPutWithTheEncodedUser() async throws {
        let (api, client) = api(.response(status: 200, body: sampleUserJSON))
        let user = UserDTO(
            id: SampleServer.seedID(1), fullName: "Ada Lovelace", email: "ada@example.com",
            role: "admin", isActive: true, joinedAt: Date(timeIntervalSince1970: 1_673_254_800)
        )
        let stored = try await api.update(user)
        #expect(stored == user)
        let request = try #require(await client.requests.first)
        #expect(request.httpMethod == "PUT")
        #expect(request.url?.path() == "/v1/users/00000000-0000-0000-0000-000000000001")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")
        let body = try #require(request.httpBody)
        #expect(try JSONCoding.makeDecoder().decode(UserDTO.self, from: body) == user)
    }

    @Test func aBodyThatCannotBeEncodedStopsTheRequest() {
        // JSONEncoder rejects non-finite numbers by default, so nothing would be sent.
        #expect(throws: DirectoryError.invalidRequest) { try UsersAPI.encode(Double.nan) }
    }

    @Test(arguments: [
        (401, "", DirectoryError.unauthorized),
        (403, "", .unauthorized),
        (404, "", .notFound),
        (409, #"{"error":"email_taken"}"#, .emailAlreadyInUse),
        (409, #"{"error":"version_conflict"}"#, .server(statusCode: 409)),
        (409, "not json", .server(statusCode: 409)),
        (429, "", .server(statusCode: 429)),
        (500, "", .server(statusCode: 500)),
        (302, "", .server(statusCode: 302))
    ])
    func mapsStatusCodesToDomainErrors(status: Int, body: String, expected: DirectoryError) async {
        let (api, _) = api(.response(status: status, body: body))
        await #expect(throws: expected) { try await api.fetchUsers() }
    }

    @Test func everySuccessStatusIsAccepted() {
        #expect(UsersAPI.map(statusCode: 200, body: Data()) == nil)
        #expect(UsersAPI.map(statusCode: 204, body: Data()) == nil)
        #expect(UsersAPI.map(statusCode: 299, body: Data()) == nil)
        #expect(UsersAPI.map(statusCode: 300, body: Data()) == .server(statusCode: 300))
    }

    @Test(arguments: [URLError.Code.notConnectedToInternet, .timedOut, .cannotFindHost, .networkConnectionLost])
    func connectionProblemsMeanOffline(_ code: URLError.Code) async {
        let (api, _) = api(.failure(URLError(code)))
        await #expect(throws: DirectoryError.offline) { try await api.fetchUsers() }
    }

    @Test func otherTransportErrorsMeanAnUnusableResponse() async {
        await #expect(throws: DirectoryError.invalidResponse) {
            try await api(.failure(URLError(.badServerResponse))).0.fetchUsers()
        }
        await #expect(throws: DirectoryError.invalidResponse) {
            try await api(.failure(CocoaError(.fileReadUnknown))).0.fetchUsers()
        }
    }

    @Test(arguments: ["", "{}", #"{"users":[{"id":"nope"}]}"#, #"{"users":null}"#, "[]"])
    func malformedBodiesAreInvalidResponses(_ body: String) async {
        let (api, _) = api(.response(status: 200, body: body))
        await #expect(throws: DirectoryError.invalidResponse) { try await api.fetchUsers() }
    }
}

@Suite("UserDTO")
struct UserDTOTests {
    @Test func roundTripsThroughTheDomainModel() throws {
        let dto = try JSONCoding.makeDecoder().decode(UserDTO.self, from: Data(sampleUserJSON.utf8))
        let user = try #require(dto.domainUser)
        #expect(user.role == .admin)
        #expect(UserDTO(user) == dto)
    }

    @Test func unknownRoleFromANewerServerIsDroppedNotACrash() throws {
        let json = sampleUserJSON.replacingOccurrences(of: #""admin""#, with: #""owner""#)
        let dto = try JSONCoding.makeDecoder().decode(UserDTO.self, from: Data(json.utf8))
        #expect(dto.role == "owner")
        #expect(dto.domainUser == nil)
    }
}
