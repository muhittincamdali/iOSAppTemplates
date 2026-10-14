import CleanArchitectureAppData
import CleanArchitectureAppDomain
import CleanArchitectureAppPresentation
import Foundation

/// The composition root: the only place that knows every layer.
///
/// It creates the HTTP client, the cache and the repository (Data), the use cases (Domain)
/// and the models the screens observe (Presentation). To talk to your own server, call
/// ``init(client:baseURL:cache:controls:actingUserID:)`` with a ``URLSessionHTTPClient``
/// and your base URL instead of using ``sample(cacheURL:latency:)``.
@MainActor
public final class CleanArchitectureAppContainer {
    public let directory: DirectoryModel
    public let settings: SettingsModel

    public init(
        client: any HTTPClient,
        baseURL: URL,
        cache: any UserCache,
        controls: any BackendControls,
        actingUserID: User.ID?
    ) {
        let repository = DefaultUserRepository(api: UsersAPI(baseURL: baseURL, client: client), cache: cache)
        directory = DirectoryModel(
            listUsers: ListUsersUseCase(repository: repository),
            updateProfile: UpdateProfileUseCase(repository: repository),
            setUserActive: SetUserActiveUseCase(repository: repository),
            actingUserID: actingUserID
        )
        settings = SettingsModel(controls: controls)
    }

    /// The app as it ships: the in-process ``SampleServer``, a cache file on the device, and
    /// Ada Lovelace (an admin) signed in.
    public static func sample(
        cacheURL: URL = defaultCacheURL,
        latency: Duration = .milliseconds(300)
    ) -> CleanArchitectureAppContainer {
        let server = SampleServer(latency: latency)
        let cache = FileUserCache(fileURL: cacheURL)
        return CleanArchitectureAppContainer(
            client: server,
            baseURL: SampleServer.baseURL,
            cache: cache,
            controls: SampleBackendControls(server: server, cache: cache),
            actingUserID: SampleServer.seedID(1)
        )
    }

    /// `Library/Caches/CleanArchitectureApp/directory.json`. The system may delete it when
    /// storage runs low, which only costs the offline copy.
    public nonisolated static var defaultCacheURL: URL {
        URL.cachesDirectory.appending(path: "CleanArchitectureApp/directory.json")
    }
}

/// Connects the Settings tab to the sample server and the cache. The Presentation layer
/// defines ``BackendControls``; this type implements it, so the screens never see the Data layer.
public struct SampleBackendControls: BackendControls {
    private let server: SampleServer
    private let cache: any UserCache

    public init(server: SampleServer, cache: any UserCache) {
        self.server = server
        self.cache = cache
    }

    public func isServerReachable() async -> Bool {
        await server.reachable
    }

    public func setServerReachable(_ reachable: Bool) async {
        await server.setReachable(reachable)
    }

    public func clearSavedDirectory() async throws {
        try await cache.clear()
    }
}
