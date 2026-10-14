import Foundation

/// The last directory the server returned, as stored on the device.
public struct CachedDirectory: Codable, Equatable, Sendable {
    /// Bumped when the stored format changes; older files are ignored.
    public static let currentVersion = 1

    public var version: Int
    public var savedAt: Date
    public var users: [UserDTO]

    public init(savedAt: Date, users: [UserDTO]) {
        self.version = Self.currentVersion
        self.savedAt = savedAt
        self.users = users
    }
}

public protocol UserCache: Sendable {
    /// The saved directory, or nil if nothing usable is saved.
    func load() async -> CachedDirectory?
    func save(_ directory: CachedDirectory) async throws
    func clear() async throws
}

/// Keeps the directory in a JSON file. Writes are atomic, so a crash never leaves half a file,
/// and on iOS the file is encrypted until the device is unlocked for the first time after a
/// restart, because it holds names and email addresses.
public actor FileUserCache: UserCache {
    public let fileURL: URL

    public init(fileURL: URL) {
        self.fileURL = fileURL
    }

    /// A missing, unreadable or outdated file counts as an empty cache.
    public func load() -> CachedDirectory? {
        guard let data = try? Data(contentsOf: fileURL),
              let directory = try? JSONCoding.makeDecoder().decode(CachedDirectory.self, from: data),
              directory.version == CachedDirectory.currentVersion
        else { return nil }
        return directory
    }

    public func save(_ directory: CachedDirectory) throws {
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try JSONCoding.makeEncoder().encode(directory).write(to: fileURL, options: Self.writingOptions)
    }

    #if os(iOS)
    static let writingOptions: Data.WritingOptions = [.atomic, .completeFileProtectionUntilFirstUserAuthentication]
    #else
    static let writingOptions: Data.WritingOptions = [.atomic]
    #endif

    public func clear() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        try FileManager.default.removeItem(at: fileURL)
    }
}

/// A cache that lives as long as the process; useful for previews and tests.
public actor InMemoryUserCache: UserCache {
    private var directory: CachedDirectory?

    public init(_ directory: CachedDirectory? = nil) {
        self.directory = directory
    }

    public func load() -> CachedDirectory? {
        directory
    }

    public func save(_ directory: CachedDirectory) {
        self.directory = directory
    }

    public func clear() {
        directory = nil
    }
}
