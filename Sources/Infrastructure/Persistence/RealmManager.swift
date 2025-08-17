//
// RealmManager.swift
// iOS App Templates
//
// Created on 16/08/2024.
//

import Foundation
import Combine

// MARK: - Realm Protocol (Abstraction)
public protocol RealmProtocol {
    func write<Result>(_ block: () throws -> Result) throws -> Result
    func delete(_ object: Any) throws
    func deleteAll() throws
    func objects<T>(_ type: T.Type) -> Results<T> where T: RealmObject
    func object<T>(_ type: T.Type, forPrimaryKey key: Any) -> T? where T: RealmObject
    func add(_ object: Any, update: Bool) throws
}

// MARK: - Realm Object Protocol
public protocol RealmObject: AnyObject {
    static var primaryKey: String? { get }
    var id: String { get }
}

// MARK: - Results Protocol
public protocol Results<Element> {
    func filter(_ predicate: NSPredicate) -> Self
    func sorted(byKeyPath keyPath: String, ascending: Bool) -> Self
    var count: Int { get }
    func toArray() -> [Element]
}

// MARK: - Realm Manager
public final class RealmManager {
    
    // MARK: - Singleton
    public static let shared = RealmManager()
    
    // MARK: - Properties
    private let configuration: Configuration
    private let encryptionManager: RealmEncryptionManager
    private let migrationManager: RealmMigrationManager
    private let logger: RealmLogger
    private let cache: RealmCache
    
    private var realmInstances: [String: RealmProtocol] = [:]
    private let queue = DispatchQueue(label: "com.iosapptemplates.realm", attributes: .concurrent)
    
    // MARK: - Configuration
    public struct Configuration {
        public let databaseName: String
        public let schemaVersion: UInt64
        public let encryptionKey: Data?
        public let inMemory: Bool
        public let readOnly: Bool
        public let compactOnLaunch: Bool
        public let deleteOnMigrationFailure: Bool
        public let loggingEnabled: Bool
        public let cacheEnabled: Bool
        public let maxCacheSize: Int
        
        public init(
            databaseName: String = "default",
            schemaVersion: UInt64 = 1,
            encryptionKey: Data? = nil,
            inMemory: Bool = false,
            readOnly: Bool = false,
            compactOnLaunch: Bool = true,
            deleteOnMigrationFailure: Bool = false,
            loggingEnabled: Bool = false,
            cacheEnabled: Bool = true,
            maxCacheSize: Int = 1000
        ) {
            self.databaseName = databaseName
            self.schemaVersion = schemaVersion
            self.encryptionKey = encryptionKey
            self.inMemory = inMemory
            self.readOnly = readOnly
            self.compactOnLaunch = compactOnLaunch
            self.deleteOnMigrationFailure = deleteOnMigrationFailure
            self.loggingEnabled = loggingEnabled
            self.cacheEnabled = cacheEnabled
            self.maxCacheSize = maxCacheSize
        }
    }
    
    // MARK: - Initialization
    private init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        self.encryptionManager = RealmEncryptionManager(key: configuration.encryptionKey)
        self.migrationManager = RealmMigrationManager(schemaVersion: configuration.schemaVersion)
        self.logger = RealmLogger(enabled: configuration.loggingEnabled)
        self.cache = RealmCache(enabled: configuration.cacheEnabled, maxSize: configuration.maxCacheSize)
        
        setupRealm()
    }
    
    // MARK: - Setup
    private func setupRealm() {
        logger.log("Setting up Realm with configuration: \(configuration)")
        
        // Setup migration if needed
        migrationManager.performMigrationIfNeeded()
        
        // Compact on launch if configured
        if configuration.compactOnLaunch {
            compactDatabase()
        }
    }
    
    // MARK: - Realm Instance Management
    public func realm(for identifier: String = "default") throws -> RealmProtocol {
        return try queue.sync {
            if let existingRealm = realmInstances[identifier] {
                return existingRealm
            }
            
            let realm = try createRealmInstance(identifier: identifier)
            realmInstances[identifier] = realm
            return realm
        }
    }
    
    private func createRealmInstance(identifier: String) throws -> RealmProtocol {
        // This would create actual Realm instance
        // For now, returning a mock implementation
        return MockRealm(configuration: configuration, logger: logger)
    }
    
    // MARK: - CRUD Operations
    public func save<T: RealmObject>(_ object: T, update: Bool = true) -> AnyPublisher<T, Error> {
        Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RealmError.deallocated))
                return
            }
            
            self.queue.async(flags: .barrier) {
                do {
                    let realm = try self.realm()
                    try realm.write {
                        realm.add(object, update: update)
                    }
                    
                    self.logger.log("Saved object: \(type(of: object)) with id: \(object.id)")
                    self.cache.set(object, for: object.id)
                    
                    promise(.success(object))
                } catch {
                    self.logger.log("Failed to save object: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func fetch<T: RealmObject>(_ type: T.Type, id: String) -> AnyPublisher<T?, Never> {
        Future<T?, Never> { [weak self] promise in
            guard let self = self else {
                promise(.success(nil))
                return
            }
            
            // Check cache first
            if let cached: T = self.cache.get(for: id) {
                self.logger.log("Cache hit for \(type) with id: \(id)")
                promise(.success(cached))
                return
            }
            
            self.queue.async {
                do {
                    let realm = try self.realm()
                    let object = realm.object(type, forPrimaryKey: id)
                    
                    if let object = object {
                        self.cache.set(object, for: id)
                    }
                    
                    promise(.success(object))
                } catch {
                    self.logger.log("Failed to fetch object: \(error)")
                    promise(.success(nil))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func fetchAll<T: RealmObject>(_ type: T.Type) -> AnyPublisher<[T], Error> {
        Future<[T], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RealmError.deallocated))
                return
            }
            
            self.queue.async {
                do {
                    let realm = try self.realm()
                    let objects = realm.objects(type).toArray()
                    
                    self.logger.log("Fetched \(objects.count) objects of type \(type)")
                    
                    // Cache objects
                    objects.forEach { object in
                        self.cache.set(object, for: object.id)
                    }
                    
                    promise(.success(objects))
                } catch {
                    self.logger.log("Failed to fetch objects: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func delete<T: RealmObject>(_ object: T) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RealmError.deallocated))
                return
            }
            
            self.queue.async(flags: .barrier) {
                do {
                    let realm = try self.realm()
                    try realm.write {
                        realm.delete(object)
                    }
                    
                    self.logger.log("Deleted object: \(type(of: object)) with id: \(object.id)")
                    self.cache.remove(for: object.id)
                    
                    promise(.success(()))
                } catch {
                    self.logger.log("Failed to delete object: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteAll() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RealmError.deallocated))
                return
            }
            
            self.queue.async(flags: .barrier) {
                do {
                    let realm = try self.realm()
                    try realm.write {
                        realm.deleteAll()
                    }
                    
                    self.logger.log("Deleted all objects")
                    self.cache.clear()
                    
                    promise(.success(()))
                } catch {
                    self.logger.log("Failed to delete all objects: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Query Operations
    public func query<T: RealmObject>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sortKeyPath: String? = nil,
        ascending: Bool = true
    ) -> AnyPublisher<[T], Error> {
        Future<[T], Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RealmError.deallocated))
                return
            }
            
            self.queue.async {
                do {
                    let realm = try self.realm()
                    var results = realm.objects(type)
                    
                    if let predicate = predicate {
                        results = results.filter(predicate)
                    }
                    
                    if let sortKeyPath = sortKeyPath {
                        results = results.sorted(byKeyPath: sortKeyPath, ascending: ascending)
                    }
                    
                    let objects = results.toArray()
                    self.logger.log("Query returned \(objects.count) objects")
                    
                    promise(.success(objects))
                } catch {
                    self.logger.log("Query failed: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Transaction Management
    public func transaction<T>(_ block: @escaping () throws -> T) -> AnyPublisher<T, Error> {
        Future<T, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(RealmError.deallocated))
                return
            }
            
            self.queue.async(flags: .barrier) {
                do {
                    let realm = try self.realm()
                    let result = try realm.write {
                        try block()
                    }
                    
                    self.logger.log("Transaction completed successfully")
                    promise(.success(result))
                } catch {
                    self.logger.log("Transaction failed: \(error)")
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Database Management
    public func compactDatabase() {
        logger.log("Compacting database...")
        // Compact implementation
    }
    
    public func exportDatabase(to url: URL) throws {
        logger.log("Exporting database to \(url)")
        // Export implementation
    }
    
    public func importDatabase(from url: URL) throws {
        logger.log("Importing database from \(url)")
        // Import implementation
    }
    
    public func resetDatabase() throws {
        logger.log("Resetting database")
        try deleteAll().sink(
            receiveCompletion: { _ in },
            receiveValue: { _ in }
        ).store(in: &Set<AnyCancellable>())
    }
}

// MARK: - Realm Error
public enum RealmError: LocalizedError {
    case deallocated
    case configurationError
    case migrationError
    case encryptionError
    case transactionError
    case queryError
    
    public var errorDescription: String? {
        switch self {
        case .deallocated:
            return "Realm manager was deallocated"
        case .configurationError:
            return "Realm configuration error"
        case .migrationError:
            return "Realm migration failed"
        case .encryptionError:
            return "Realm encryption error"
        case .transactionError:
            return "Realm transaction failed"
        case .queryError:
            return "Realm query failed"
        }
    }
}

// MARK: - Realm Encryption Manager
private class RealmEncryptionManager {
    private let encryptionKey: Data?
    
    init(key: Data?) {
        self.encryptionKey = key
    }
    
    func generateKey() -> Data {
        var key = Data(count: 64)
        key.withUnsafeMutableBytes { bytes in
            _ = SecRandomCopyBytes(kSecRandomDefault, 64, bytes.baseAddress!)
        }
        return key
    }
    
    func storeKey(_ key: Data) {
        // Store in keychain
    }
    
    func retrieveKey() -> Data? {
        // Retrieve from keychain
        return encryptionKey
    }
}

// MARK: - Realm Migration Manager
private class RealmMigrationManager {
    private let schemaVersion: UInt64
    
    init(schemaVersion: UInt64) {
        self.schemaVersion = schemaVersion
    }
    
    func performMigrationIfNeeded() {
        // Migration logic
    }
}

// MARK: - Realm Cache
private class RealmCache {
    private let enabled: Bool
    private let maxSize: Int
    private var storage: [String: Any] = [:]
    private let queue = DispatchQueue(label: "com.iosapptemplates.realm.cache", attributes: .concurrent)
    
    init(enabled: Bool, maxSize: Int) {
        self.enabled = enabled
        self.maxSize = maxSize
    }
    
    func get<T>(for key: String) -> T? {
        guard enabled else { return nil }
        
        return queue.sync {
            storage[key] as? T
        }
    }
    
    func set<T>(_ value: T, for key: String) {
        guard enabled else { return }
        
        queue.async(flags: .barrier) {
            self.storage[key] = value
            
            // Evict if exceeds max size
            if self.storage.count > self.maxSize {
                self.storage.removeFirst()
            }
        }
    }
    
    func remove(for key: String) {
        guard enabled else { return }
        
        queue.async(flags: .barrier) {
            self.storage.removeValue(forKey: key)
        }
    }
    
    func clear() {
        guard enabled else { return }
        
        queue.async(flags: .barrier) {
            self.storage.removeAll()
        }
    }
}

// MARK: - Realm Logger
private class RealmLogger {
    private let enabled: Bool
    
    init(enabled: Bool) {
        self.enabled = enabled
    }
    
    func log(_ message: String) {
        guard enabled else { return }
        print("[Realm] \(Date()) - \(message)")
    }
}

// MARK: - Mock Realm Implementation
private class MockRealm: RealmProtocol {
    private let configuration: RealmManager.Configuration
    private let logger: RealmLogger
    private var storage: [String: Any] = [:]
    
    init(configuration: RealmManager.Configuration, logger: RealmLogger) {
        self.configuration = configuration
        self.logger = logger
    }
    
    func write<Result>(_ block: () throws -> Result) throws -> Result {
        return try block()
    }
    
    func delete(_ object: Any) throws {
        if let realmObject = object as? RealmObject {
            storage.removeValue(forKey: realmObject.id)
        }
    }
    
    func deleteAll() throws {
        storage.removeAll()
    }
    
    func objects<T>(_ type: T.Type) -> Results<T> where T: RealmObject {
        let objects = storage.values.compactMap { $0 as? T }
        return MockResults(objects: objects)
    }
    
    func object<T>(_ type: T.Type, forPrimaryKey key: Any) -> T? where T: RealmObject {
        guard let keyString = key as? String else { return nil }
        return storage[keyString] as? T
    }
    
    func add(_ object: Any, update: Bool) throws {
        if let realmObject = object as? RealmObject {
            storage[realmObject.id] = realmObject
        }
    }
}

// MARK: - Mock Results
private struct MockResults<T>: Results {
    typealias Element = T
    
    private var objects: [T]
    
    init(objects: [T]) {
        self.objects = objects
    }
    
    func filter(_ predicate: NSPredicate) -> Self {
        let filtered = (objects as NSArray).filtered(using: predicate) as? [T] ?? []
        return MockResults(objects: filtered)
    }
    
    func sorted(byKeyPath keyPath: String, ascending: Bool) -> Self {
        // Simple sort implementation
        return self
    }
    
    var count: Int {
        objects.count
    }
    
    func toArray() -> [T] {
        objects
    }
}