@testable import CleanArchitectureAppData
import CleanArchitectureAppDomain
import Foundation
import Testing

private let fixedNow = Date(timeIntervalSince1970: 1_800_000_000)

private func repository(
    server: SampleServer = SampleServer(),
    cache: InMemoryUserCache = InMemoryUserCache()
) -> DefaultUserRepository {
    DefaultUserRepository(
        api: UsersAPI(baseURL: SampleServer.baseURL, client: server),
        cache: cache,
        now: { fixedNow }
    )
}

private func repository(replying reply: StubHTTPClient.Reply, cache: InMemoryUserCache) -> DefaultUserRepository {
    DefaultUserRepository(api: UsersAPI(baseURL: SampleServer.baseURL, client: StubHTTPClient(reply)), cache: cache)
}

@Suite("DefaultUserRepository")
struct DefaultUserRepositoryTests {
    @Test func successfulFetchComesFromTheServerAndReplacesTheSavedCopy() async throws {
        let cache = InMemoryUserCache()
        let snapshot = try await repository(cache: cache).users()

        #expect(snapshot.origin == .server)
        #expect(snapshot.users.count == SampleServer.seedUsers.count)
        let saved = try #require(await cache.load())
        #expect(saved.savedAt == fixedNow)
        #expect(saved.users == SampleServer.seedUsers)
    }

    @Test func offlineFallsBackToTheSavedCopyAndSaysWhenItWasSaved() async throws {
        let server = SampleServer()
        let cache = InMemoryUserCache()
        let repository = repository(server: server, cache: cache)
        _ = try await repository.users()
        await server.setReachable(false)

        let snapshot = try await repository.users()

        #expect(snapshot.origin == .cache(savedAt: fixedNow))
        #expect(snapshot.users.count == SampleServer.seedUsers.count)
    }

    @Test func offlineWithoutASavedCopyIsAnError() async {
        let server = SampleServer()
        await server.setReachable(false)
        await #expect(throws: DirectoryError.offline) { try await repository(server: server).users() }
    }

    @Test(arguments: [500, 502, 503, 599])
    func serverErrorsFallBackToTheSavedCopy(status: Int) async throws {
        let cache = InMemoryUserCache(CachedDirectory(savedAt: fixedNow, users: SampleServer.seedUsers))
        let snapshot = try await repository(replying: .response(status: status, body: ""), cache: cache).users()
        #expect(snapshot.origin == .cache(savedAt: fixedNow))
    }

    @Test(arguments: [401, 403, 404, 429])
    func otherErrorsAreNotHiddenByTheSavedCopy(status: Int) async throws {
        let cache = InMemoryUserCache(CachedDirectory(savedAt: fixedNow, users: SampleServer.seedUsers))
        await #expect(throws: DirectoryError.self) {
            try await repository(replying: .response(status: status, body: ""), cache: cache).users()
        }
    }

    @Test func unreadableResponseIsNotHiddenByTheSavedCopy() async {
        let cache = InMemoryUserCache(CachedDirectory(savedAt: fixedNow, users: SampleServer.seedUsers))
        await #expect(throws: DirectoryError.invalidResponse) {
            try await repository(replying: .response(status: 200, body: "<html>"), cache: cache).users()
        }
    }

    @Test func recordsWithUnknownRolesAreLeftOut() async throws {
        var future = SampleServer.seedUsers[0]
        future.role = "owner"
        let server = SampleServer(users: [future] + SampleServer.seedUsers.dropFirst())
        let snapshot = try await repository(server: server).users()
        #expect(snapshot.users.count == SampleServer.seedUsers.count - 1)
        #expect(!snapshot.users.contains { $0.id == future.id })
    }

    @Test func savingUpdatesTheServerAndTheSavedCopy() async throws {
        let server = SampleServer()
        let cache = InMemoryUserCache()
        let repository = repository(server: server, cache: cache)
        var user = try #require(try await repository.users().users.first { $0.id == SampleServer.seedID(4) })
        user.name = "Zoë Martin-Durand"
        user.email = "ZOE@example.com"

        let stored = try await repository.save(user)

        #expect(stored.name == "Zoë Martin-Durand")
        #expect(stored.email == "zoe@example.com", "the server stores email addresses in lowercase")
        #expect(await cache.load()?.users.first { $0.id == user.id }?.fullName == "Zoë Martin-Durand")
        await server.setReachable(false)
        #expect(try await repository.users().users.first { $0.id == user.id }?.name == "Zoë Martin-Durand")
    }

    @Test func savingWithoutASavedCopyDoesNotCreateAPartialOne() async throws {
        let cache = InMemoryUserCache()
        let user = try #require(SampleServer.seedUsers[0].domainUser)
        _ = try await repository(cache: cache).save(user)
        #expect(await cache.load() == nil)
    }

    @Test func savingWhileOfflineFailsAndLeavesTheSavedCopyAlone() async throws {
        let server = SampleServer()
        let cache = InMemoryUserCache()
        let repository = repository(server: server, cache: cache)
        var user = try #require(try await repository.users().users.first)
        let before = await cache.load()
        await server.setReachable(false)
        user.name = "Changed Offline"

        await #expect(throws: DirectoryError.offline) { try await repository.save(user) }
        #expect(await cache.load() == before)
    }

    @Test func emailTakenByAnotherAccountIsReported() async throws {
        let repository = repository()
        var user = try #require(try await repository.users().users.first { $0.id == SampleServer.seedID(4) })
        user.email = "ADA.LOVELACE@example.com"
        await #expect(throws: DirectoryError.emailAlreadyInUse) { try await repository.save(user) }
    }

    @Test func savingSomeoneTheServerDoesNotKnowIsNotFound() async {
        let stranger = User(id: UUID(), name: "Nobody", email: "nobody@example.com", role: .member, isActive: true, joinedAt: fixedNow)
        await #expect(throws: DirectoryError.notFound) { try await repository().save(stranger) }
    }
}

@Suite("SampleServer")
struct SampleServerTests {
    private func request(_ method: String, _ path: String, body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: SampleServer.baseURL.appending(path: path))
        request.httpMethod = method
        request.httpBody = body
        return request
    }

    @Test func rejectsABodyWhoseIDDoesNotMatchThePath() async throws {
        let body = try JSONCoding.makeEncoder().encode(SampleServer.seedUsers[1])
        let (_, response) = try await SampleServer().send(request("PUT", "v1/users/\(SampleServer.seedID(1).uuidString)", body: body))
        #expect(response.statusCode == 400)
    }

    @Test func rejectsARoleItDoesNotKnow() async throws {
        var user = SampleServer.seedUsers[0]
        user.role = "superuser"
        let body = try JSONCoding.makeEncoder().encode(user)
        let server = SampleServer()
        let (_, response) = try await server.send(request("PUT", "v1/users/\(user.id.uuidString)", body: body))
        #expect(response.statusCode == 400)
        let (data, _) = try await server.send(request("GET", "v1/users"))
        #expect(try JSONCoding.makeDecoder().decode(UserListDTO.self, from: data).users.allSatisfy { $0.role != "superuser" })
    }

    @Test(arguments: [nil, Data("{".utf8), Data()])
    func rejectsMissingOrBrokenBodies(_ body: Data?) async throws {
        let (_, response) = try await SampleServer().send(request("PUT", "v1/users/\(SampleServer.seedID(1).uuidString)", body: body))
        #expect(response.statusCode == 400)
    }

    @Test(arguments: [("GET", "v1/nothing"), ("DELETE", "v1/users"), ("PUT", "v1/users/not-a-uuid"), ("PUT", "v1/users/a/b")])
    func unknownRoutesAndIDsAreNotFound(method: String, path: String) async throws {
        let (_, response) = try await SampleServer().send(request(method, path))
        #expect(response.statusCode == 404)
    }

    @Test func listsUsersInAStableOrder() async throws {
        let (first, _) = try await SampleServer().send(request("GET", "v1/users"))
        let (second, _) = try await SampleServer().send(request("GET", "v1/users"))
        #expect(first == second)
    }

    @Test func unreachableServerThrowsANetworkError() async {
        let server = SampleServer()
        await server.setReachable(false)
        #expect(await !server.reachable)
        await #expect(throws: URLError.self) { try await server.send(request("GET", "v1/users")) }
    }
}

@Suite("FileUserCache")
struct FileUserCacheTests {
    private func withCacheFile(_ body: (URL) async throws -> Void) async throws {
        let directory = FileManager.default.temporaryDirectory.appending(path: "FileUserCacheTests-\(UUID().uuidString)")
        defer { try? FileManager.default.removeItem(at: directory) }
        try await body(directory.appending(path: "nested/directory.json"))
    }

    @Test func savesAndLoadsTheDirectoryCreatingFoldersAsNeeded() async throws {
        try await withCacheFile { url in
            let cache = FileUserCache(fileURL: url)
            let directory = CachedDirectory(savedAt: fixedNow, users: SampleServer.seedUsers)
            try await cache.save(directory)
            #expect(await cache.load() == directory)
            #expect(await FileUserCache(fileURL: url).load() == directory, "a new instance reads the same file")
        }
    }

    @Test func missingCorruptOrOutdatedFilesCountAsEmpty() async throws {
        try await withCacheFile { url in
            let cache = FileUserCache(fileURL: url)
            #expect(await cache.load() == nil)

            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            try Data("{ not json".utf8).write(to: url)
            #expect(await cache.load() == nil)

            var outdated = CachedDirectory(savedAt: fixedNow, users: [])
            outdated.version = CachedDirectory.currentVersion + 1
            try JSONCoding.makeEncoder().encode(outdated).write(to: url)
            #expect(await cache.load() == nil)
        }
    }

    @Test func clearRemovesTheFileAndIsSafeToRepeat() async throws {
        try await withCacheFile { url in
            let cache = FileUserCache(fileURL: url)
            try await cache.save(CachedDirectory(savedAt: fixedNow, users: []))
            try await cache.clear()
            try await cache.clear()
            #expect(!FileManager.default.fileExists(atPath: url.path()))
            #expect(await cache.load() == nil)
        }
    }
}
