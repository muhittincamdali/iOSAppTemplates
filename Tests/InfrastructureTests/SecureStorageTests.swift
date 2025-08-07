import XCTest
import Security
@testable import iOSAppTemplates

final class SecureStorageTests: XCTestCase {
    var secureStorage: SecureStorage!
    var mockKeychainService: MockKeychainService!
    
    override func setUp() {
        super.setUp()
        mockKeychainService = MockKeychainService()
        secureStorage = SecureStorage(keychainService: mockKeychainService)
    }
    
    override func tearDown() {
        secureStorage = nil
        mockKeychainService = nil
        super.tearDown()
    }
    
    // MARK: - Save Data Tests
    
    func testSaveSecureDataSuccess() async throws {
        // Given
        let testData = "sensitive data".data(using: .utf8)!
        let testKey = "test-key"
        mockKeychainService.shouldSucceed = true
        
        // When
        try await secureStorage.saveSecureData(testData, for: testKey)
        
        // Then
        XCTAssertTrue(mockKeychainService.saveCalled)
        XCTAssertEqual(mockKeychainService.lastSavedKey, testKey)
        XCTAssertEqual(mockKeychainService.lastSavedData, testData)
    }
    
    func testSaveSecureDataFailure() async throws {
        // Given
        let testData = "sensitive data".data(using: .utf8)!
        let testKey = "test-key"
        mockKeychainService.shouldSucceed = false
        mockKeychainService.mockError = KeychainError.saveFailed
        
        // When & Then
        do {
            try await secureStorage.saveSecureData(testData, for: testKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? KeychainError, .saveFailed)
        }
    }
    
    func testSaveSecureDataWithEmptyKey() async throws {
        // Given
        let testData = "sensitive data".data(using: .utf8)!
        let emptyKey = ""
        
        // When & Then
        do {
            try await secureStorage.saveSecureData(testData, for: emptyKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SecureStorageError, .invalidKey)
        }
    }
    
    func testSaveSecureDataWithEmptyData() async throws {
        // Given
        let emptyData = Data()
        let testKey = "test-key"
        
        // When & Then
        do {
            try await secureStorage.saveSecureData(emptyData, for: testKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SecureStorageError, .invalidData)
        }
    }
    
    // MARK: - Retrieve Data Tests
    
    func testRetrieveSecureDataSuccess() async throws {
        // Given
        let expectedData = "retrieved data".data(using: .utf8)!
        let testKey = "test-key"
        mockKeychainService.shouldSucceed = true
        mockKeychainService.mockData = expectedData
        
        // When
        let retrievedData = try await secureStorage.retrieveSecureData(for: testKey)
        
        // Then
        XCTAssertEqual(retrievedData, expectedData)
        XCTAssertTrue(mockKeychainService.retrieveCalled)
        XCTAssertEqual(mockKeychainService.lastRetrievedKey, testKey)
    }
    
    func testRetrieveSecureDataNotFound() async throws {
        // Given
        let testKey = "nonexistent-key"
        mockKeychainService.shouldSucceed = false
        mockKeychainService.mockError = KeychainError.itemNotFound
        
        // When & Then
        do {
            _ = try await secureStorage.retrieveSecureData(for: testKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? KeychainError, .itemNotFound)
        }
    }
    
    func testRetrieveSecureDataWithEmptyKey() async throws {
        // Given
        let emptyKey = ""
        
        // When & Then
        do {
            _ = try await secureStorage.retrieveSecureData(for: emptyKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SecureStorageError, .invalidKey)
        }
    }
    
    // MARK: - Delete Data Tests
    
    func testDeleteSecureDataSuccess() async throws {
        // Given
        let testKey = "test-key"
        mockKeychainService.shouldSucceed = true
        
        // When
        try await secureStorage.deleteSecureData(for: testKey)
        
        // Then
        XCTAssertTrue(mockKeychainService.deleteCalled)
        XCTAssertEqual(mockKeychainService.lastDeletedKey, testKey)
    }
    
    func testDeleteSecureDataFailure() async throws {
        // Given
        let testKey = "test-key"
        mockKeychainService.shouldSucceed = false
        mockKeychainService.mockError = KeychainError.deleteFailed
        
        // When & Then
        do {
            try await secureStorage.deleteSecureData(for: testKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? KeychainError, .deleteFailed)
        }
    }
    
    func testDeleteSecureDataWithEmptyKey() async throws {
        // Given
        let emptyKey = ""
        
        // When & Then
        do {
            try await secureStorage.deleteSecureData(for: emptyKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SecureStorageError, .invalidKey)
        }
    }
    
    // MARK: - Check Existence Tests
    
    func testDataExistsSuccess() async throws {
        // Given
        let testKey = "existing-key"
        mockKeychainService.shouldSucceed = true
        mockKeychainService.mockData = "some data".data(using: .utf8)!
        
        // When
        let exists = try await secureStorage.dataExists(for: testKey)
        
        // Then
        XCTAssertTrue(exists)
        XCTAssertTrue(mockKeychainService.retrieveCalled)
    }
    
    func testDataExistsFailure() async throws {
        // Given
        let testKey = "nonexistent-key"
        mockKeychainService.shouldSucceed = false
        mockKeychainService.mockError = KeychainError.itemNotFound
        
        // When
        let exists = try await secureStorage.dataExists(for: testKey)
        
        // Then
        XCTAssertFalse(exists)
    }
    
    func testDataExistsWithEmptyKey() async throws {
        // Given
        let emptyKey = ""
        
        // When & Then
        do {
            _ = try await secureStorage.dataExists(for: emptyKey)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? SecureStorageError, .invalidKey)
        }
    }
    
    // MARK: - Token Management Tests
    
    func testSaveTokenSuccess() async throws {
        // Given
        let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test.token"
        mockKeychainService.shouldSucceed = true
        
        // When
        try await secureStorage.saveToken(testToken)
        
        // Then
        XCTAssertTrue(mockKeychainService.saveCalled)
        XCTAssertEqual(mockKeychainService.lastSavedKey, "auth_token")
        XCTAssertEqual(mockKeychainService.lastSavedData, testToken.data(using: .utf8))
    }
    
    func testGetTokenSuccess() async throws {
        // Given
        let expectedToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.test.token"
        mockKeychainService.shouldSucceed = true
        mockKeychainService.mockData = expectedToken.data(using: .utf8)!
        
        // When
        let token = try await secureStorage.getToken()
        
        // Then
        XCTAssertEqual(token, expectedToken)
        XCTAssertTrue(mockKeychainService.retrieveCalled)
        XCTAssertEqual(mockKeychainService.lastRetrievedKey, "auth_token")
    }
    
    func testGetTokenNotFound() async throws {
        // Given
        mockKeychainService.shouldSucceed = false
        mockKeychainService.mockError = KeychainError.itemNotFound
        
        // When
        let token = try await secureStorage.getToken()
        
        // Then
        XCTAssertNil(token)
    }
    
    func testDeleteTokenSuccess() async throws {
        // Given
        mockKeychainService.shouldSucceed = true
        
        // When
        try await secureStorage.deleteToken()
        
        // Then
        XCTAssertTrue(mockKeychainService.deleteCalled)
        XCTAssertEqual(mockKeychainService.lastDeletedKey, "auth_token")
    }
    
    // MARK: - Credential Management Tests
    
    func testSaveCredentialsSuccess() async throws {
        // Given
        let username = "testuser"
        let password = "testpassword"
        let credentials = Credentials(username: username, password: password)
        mockKeychainService.shouldSucceed = true
        
        // When
        try await secureStorage.saveCredentials(credentials, for: "test-service")
        
        // Then
        XCTAssertTrue(mockKeychainService.saveCalled)
        XCTAssertEqual(mockKeychainService.lastSavedKey, "credentials_test-service")
    }
    
    func testGetCredentialsSuccess() async throws {
        // Given
        let expectedCredentials = Credentials(username: "testuser", password: "testpassword")
        mockKeychainService.shouldSucceed = true
        mockKeychainService.mockData = try JSONEncoder().encode(expectedCredentials)
        
        // When
        let credentials = try await secureStorage.getCredentials(for: "test-service")
        
        // Then
        XCTAssertEqual(credentials?.username, expectedCredentials.username)
        XCTAssertEqual(credentials?.password, expectedCredentials.password)
    }
    
    func testDeleteCredentialsSuccess() async throws {
        // Given
        mockKeychainService.shouldSucceed = true
        
        // When
        try await secureStorage.deleteCredentials(for: "test-service")
        
        // Then
        XCTAssertTrue(mockKeychainService.deleteCalled)
        XCTAssertEqual(mockKeychainService.lastDeletedKey, "credentials_test-service")
    }
    
    // MARK: - Performance Tests
    
    func testSaveDataPerformance() {
        let testData = "performance test data".data(using: .utf8)!
        let testKey = "performance-key"
        
        measure {
            let expectation = XCTestExpectation(description: "Save data performance")
            
            Task {
                try await secureStorage.saveSecureData(testData, for: testKey)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    func testRetrieveDataPerformance() {
        let testKey = "performance-key"
        mockKeychainService.mockData = "performance test data".data(using: .utf8)!
        
        measure {
            let expectation = XCTestExpectation(description: "Retrieve data performance")
            
            Task {
                _ = try await secureStorage.retrieveSecureData(for: testKey)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 1.0)
        }
    }
    
    // MARK: - Concurrent Access Tests
    
    func testConcurrentSaveOperations() async throws {
        // Given
        let testData = "concurrent test data".data(using: .utf8)!
        mockKeychainService.shouldSucceed = true
        
        // When
        await withThrowingTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    try await self.secureStorage.saveSecureData(testData, for: "concurrent-key-\(i)")
                }
            }
        }
        
        // Then
        XCTAssertEqual(mockKeychainService.saveCallCount, 10)
    }
    
    func testConcurrentRetrieveOperations() async throws {
        // Given
        mockKeychainService.shouldSucceed = true
        mockKeychainService.mockData = "concurrent test data".data(using: .utf8)!
        
        // When
        let results = await withThrowingTaskGroup(of: Data.self) { group in
            for i in 0..<10 {
                group.addTask {
                    try await self.secureStorage.retrieveSecureData(for: "concurrent-key-\(i)")
                }
            }
            
            var results: [Data] = []
            for try await result in group {
                results.append(result)
            }
            return results
        }
        
        // Then
        XCTAssertEqual(results.count, 10)
        XCTAssertEqual(mockKeychainService.retrieveCallCount, 10)
    }
}

// MARK: - Supporting Types

struct Credentials: Codable {
    let username: String
    let password: String
}

enum SecureStorageError: LocalizedError {
    case invalidKey
    case invalidData
    case encodingFailed
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidKey:
            return "Invalid key provided"
        case .invalidData:
            return "Invalid data provided"
        case .encodingFailed:
            return "Failed to encode data"
        case .decodingFailed:
            return "Failed to decode data"
        }
    }
}

enum KeychainError: LocalizedError {
    case saveFailed
    case retrieveFailed
    case deleteFailed
    case itemNotFound
    case duplicateItem
    case invalidItemFormat
    
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save item to keychain"
        case .retrieveFailed:
            return "Failed to retrieve item from keychain"
        case .deleteFailed:
            return "Failed to delete item from keychain"
        case .itemNotFound:
            return "Item not found in keychain"
        case .duplicateItem:
            return "Item already exists in keychain"
        case .invalidItemFormat:
            return "Invalid item format"
        }
    }
}

protocol KeychainServiceProtocol {
    func save(key: String, value: String) async throws
    func get(key: String) async throws -> String?
    func delete(key: String) async throws
    func saveData(key: String, data: Data) async throws
    func getData(key: String) async throws -> Data?
    func deleteData(key: String) async throws
}

class MockKeychainService: KeychainServiceProtocol {
    var shouldSucceed = true
    var mockError: Error?
    var mockData: Data?
    
    var saveCalled = false
    var retrieveCalled = false
    var deleteCalled = false
    var saveCallCount = 0
    var retrieveCallCount = 0
    var deleteCallCount = 0
    
    var lastSavedKey: String?
    var lastSavedData: Data?
    var lastRetrievedKey: String?
    var lastDeletedKey: String?
    
    func save(key: String, value: String) async throws {
        saveCalled = true
        saveCallCount += 1
        lastSavedKey = key
        lastSavedData = value.data(using: .utf8)
        
        if !shouldSucceed {
            throw mockError ?? KeychainError.saveFailed
        }
    }
    
    func get(key: String) async throws -> String? {
        retrieveCalled = true
        retrieveCallCount += 1
        lastRetrievedKey = key
        
        if !shouldSucceed {
            throw mockError ?? KeychainError.retrieveFailed
        }
        
        guard let data = mockData else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func delete(key: String) async throws {
        deleteCalled = true
        deleteCallCount += 1
        lastDeletedKey = key
        
        if !shouldSucceed {
            throw mockError ?? KeychainError.deleteFailed
        }
    }
    
    func saveData(key: String, data: Data) async throws {
        saveCalled = true
        saveCallCount += 1
        lastSavedKey = key
        lastSavedData = data
        
        if !shouldSucceed {
            throw mockError ?? KeychainError.saveFailed
        }
    }
    
    func getData(key: String) async throws -> Data? {
        retrieveCalled = true
        retrieveCallCount += 1
        lastRetrievedKey = key
        
        if !shouldSucceed {
            throw mockError ?? KeychainError.retrieveFailed
        }
        
        return mockData
    }
    
    func deleteData(key: String) async throws {
        deleteCalled = true
        deleteCallCount += 1
        lastDeletedKey = key
        
        if !shouldSucceed {
            throw mockError ?? KeychainError.deleteFailed
        }
    }
}

class SecureStorage {
    private let keychainService: KeychainServiceProtocol
    
    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }
    
    func saveSecureData(_ data: Data, for key: String) async throws {
        guard !key.isEmpty else {
            throw SecureStorageError.invalidKey
        }
        
        guard !data.isEmpty else {
            throw SecureStorageError.invalidData
        }
        
        try await keychainService.saveData(key: key, data: data)
    }
    
    func retrieveSecureData(for key: String) async throws -> Data {
        guard !key.isEmpty else {
            throw SecureStorageError.invalidKey
        }
        
        guard let data = try await keychainService.getData(key: key) else {
            throw KeychainError.itemNotFound
        }
        
        return data
    }
    
    func deleteSecureData(for key: String) async throws {
        guard !key.isEmpty else {
            throw SecureStorageError.invalidKey
        }
        
        try await keychainService.deleteData(key: key)
    }
    
    func dataExists(for key: String) async throws -> Bool {
        guard !key.isEmpty else {
            throw SecureStorageError.invalidKey
        }
        
        do {
            _ = try await keychainService.getData(key: key)
            return true
        } catch KeychainError.itemNotFound {
            return false
        }
    }
    
    func saveToken(_ token: String) async throws {
        try await keychainService.save(key: "auth_token", value: token)
    }
    
    func getToken() async throws -> String? {
        return try await keychainService.get(key: "auth_token")
    }
    
    func deleteToken() async throws {
        try await keychainService.delete(key: "auth_token")
    }
    
    func saveCredentials(_ credentials: Credentials, for service: String) async throws {
        let data = try JSONEncoder().encode(credentials)
        try await keychainService.saveData(key: "credentials_\(service)", data: data)
    }
    
    func getCredentials(for service: String) async throws -> Credentials? {
        guard let data = try await keychainService.getData(key: "credentials_\(service)") else {
            return nil
        }
        
        return try JSONDecoder().decode(Credentials.self, from: data)
    }
    
    func deleteCredentials(for service: String) async throws {
        try await keychainService.deleteData(key: "credentials_\(service)")
    }
}
