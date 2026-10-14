import CleanArchitectureAppDomain
import Foundation

/// The two endpoints the app uses, and the mapping from HTTP results to ``DirectoryError``.
///
/// - `GET  {baseURL}/v1/users` returns `{"users": [UserDTO]}`.
/// - `PUT  {baseURL}/v1/users/{id}` takes a `UserDTO` and returns the stored `UserDTO`.
///   A `409` with `{"error": "email_taken"}` means the address belongs to another account.
public struct UsersAPI: Sendable {
    static let emailTakenCode = "email_taken"

    public let baseURL: URL
    private let client: any HTTPClient

    public init(baseURL: URL, client: any HTTPClient) {
        self.baseURL = baseURL
        self.client = client
    }

    public func fetchUsers() async throws(DirectoryError) -> [UserDTO] {
        var request = URLRequest(url: baseURL.appending(path: "v1/users"))
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let data = try await send(request)
        return try decode(UserListDTO.self, from: data).users
    }

    public func update(_ user: UserDTO) async throws(DirectoryError) -> UserDTO {
        var request = URLRequest(url: baseURL.appending(path: "v1/users/\(user.id.uuidString)"))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try Self.encode(user)
        let data = try await send(request)
        return try decode(UserDTO.self, from: data)
    }

    /// A body that cannot be encoded stops the request; sending the PUT without it would
    /// ask the server to store nothing.
    static func encode(_ value: some Encodable) throws(DirectoryError) -> Data {
        do {
            return try JSONCoding.makeEncoder().encode(value)
        } catch {
            throw .invalidRequest
        }
    }

    private func send(_ request: URLRequest) async throws(DirectoryError) -> Data {
        let data: Data
        let response: HTTPURLResponse
        do {
            (data, response) = try await client.send(request)
        } catch let error as URLError {
            throw Self.map(error)
        } catch {
            throw .invalidResponse
        }
        if let error = Self.map(statusCode: response.statusCode, body: data) {
            throw error
        }
        return data
    }

    private func decode<Value: Decodable>(_ type: Value.Type, from data: Data) throws(DirectoryError) -> Value {
        do {
            return try JSONCoding.makeDecoder().decode(type, from: data)
        } catch {
            throw .invalidResponse
        }
    }

    /// Nil for a 2xx status; otherwise the domain error the status stands for.
    static func map(statusCode: Int, body: Data) -> DirectoryError? {
        switch statusCode {
        case 200..<300:
            return nil
        case 401, 403:
            return .unauthorized
        case 404:
            return .notFound
        case 409 where (try? JSONDecoder().decode(ErrorDTO.self, from: body))?.error == emailTakenCode:
            return .emailAlreadyInUse
        default:
            return .server(statusCode: statusCode)
        }
    }

    /// Connection problems become ``DirectoryError/offline``, so the repository can fall
    /// back to the saved copy; anything else means the server sent something unusable.
    static func map(_ error: URLError) -> DirectoryError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotFindHost,
             .cannotConnectToHost, .dnsLookupFailed, .dataNotAllowed, .internationalRoamingOff,
             .callIsActive, .secureConnectionFailed:
            return .offline
        default:
            return .invalidResponse
        }
    }
}
