import Foundation

/// Sends one HTTP request. `URLSessionHTTPClient` talks to a real server; `SampleServer`
/// answers in-process so the app runs without network access.
public protocol HTTPClient: Sendable {
    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
}

public struct URLSessionHTTPClient: HTTPClient {
    /// 4 MiB, far more than a directory of a few thousand people needs.
    public static let defaultMaximumResponseSize = 4 * 1024 * 1024

    private let session: URLSession
    private let maximumResponseSize: Int

    /// - Parameter maximumResponseSize: The largest body, in bytes, the client reads. A
    ///   larger body, announced or not, ends the request with `URLError(.dataLengthExceedsMaximum)`
    ///   instead of filling memory with whatever the server sends.
    public init(session: URLSession = .shared, maximumResponseSize: Int = defaultMaximumResponseSize) {
        self.session = session
        self.maximumResponseSize = maximumResponseSize
    }

    public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (bytes, response) = try await session.bytes(for: request)
        guard let http = response as? HTTPURLResponse else {
            bytes.task.cancel()
            throw URLError(.badServerResponse)
        }
        let expectedLength = http.expectedContentLength
        guard expectedLength <= Int64(maximumResponseSize) else {
            bytes.task.cancel()
            throw URLError(.dataLengthExceedsMaximum)
        }
        var data = Data()
        if expectedLength > 0 {
            data.reserveCapacity(Int(expectedLength))
        }
        for try await byte in bytes {
            guard data.count < maximumResponseSize else {
                bytes.task.cancel()
                throw URLError(.dataLengthExceedsMaximum)
            }
            data.append(byte)
        }
        return (data, http)
    }
}
