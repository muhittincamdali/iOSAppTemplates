@testable import CleanArchitectureAppData
import CleanArchitectureAppDomain
import Foundation
import Testing

/// Answers `https://sized.test/<bytes>` with a body of that many bytes, sent in 1 KiB chunks.
/// With the query `announce` the response carries a matching `Content-Length` header.
final class SizedBodyProtocol: URLProtocol {
    static let host = "sized.test"
    private static let chunkSize = 1024

    override static func canInit(with request: URLRequest) -> Bool {
        request.url?.host() == host
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url, let size = Int(url.lastPathComponent) else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }
        let headers = url.query() == "announce" ? ["Content-Length": String(size)] : [:]
        guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: headers)
        else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        var remaining = size
        while remaining > 0 {
            let count = min(Self.chunkSize, remaining)
            client?.urlProtocol(self, didLoad: Data(repeating: 0x61, count: count))
            remaining -= count
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

@Suite("URLSessionHTTPClient")
struct URLSessionHTTPClientTests {
    private static let limit = 10_000

    private func client() -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [SizedBodyProtocol.self]
        return URLSessionHTTPClient(session: URLSession(configuration: configuration), maximumResponseSize: Self.limit)
    }

    private func request(bytes: Int, announced: Bool) throws -> URLRequest {
        let query = announced ? "?announce" : ""
        return URLRequest(url: try #require(URL(string: "https://\(SizedBodyProtocol.host)/\(bytes)\(query)")))
    }

    @Test(arguments: [false, true])
    func readsABodyOfExactlyTheLimit(announced: Bool) async throws {
        let (data, response) = try await client().send(request(bytes: Self.limit, announced: announced))
        #expect(response.statusCode == 200)
        #expect(data.count == Self.limit)
    }

    @Test(arguments: [false, true])
    func stopsAtTheFirstByteOverTheLimit(announced: Bool) async throws {
        let request = try request(bytes: Self.limit + 1, announced: announced)
        let error = await #expect(throws: URLError.self) { try await client().send(request) }
        #expect(error?.code == .dataLengthExceedsMaximum)
    }

    @Test func anOversizedBodyIsAnUnusableResponseNotOffline() {
        #expect(UsersAPI.map(URLError(.dataLengthExceedsMaximum)) == .invalidResponse)
    }
}
