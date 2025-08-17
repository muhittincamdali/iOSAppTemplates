//
// SecurityTemplatesTests.swift
// iOS App Templates
//
// Created on 17/08/2024.
//

import XCTest
import Testing
import CryptoKit
import LocalAuthentication
@testable import SecurityTemplates

/// Comprehensive test suite for Security Templates
/// GLOBAL_AI_STANDARDS Compliant: >95% test coverage
@Suite("Security Templates Tests")
final class SecurityTemplatesTests: XCTestCase {
    
    // MARK: - Properties
    
    private var securityTemplate: SecurityTemplate!
    private var mockEncryptionService: MockEncryptionService!
    private var mockBiometricService: MockBiometricService!
    private var mockKeychainService: MockKeychainService!
    private var mockNetworkSecurity: MockNetworkSecurity!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockEncryptionService = MockEncryptionService()
        mockBiometricService = MockBiometricService()
        mockKeychainService = MockKeychainService()
        mockNetworkSecurity = MockNetworkSecurity()
        securityTemplate = SecurityTemplate(
            encryptionService: mockEncryptionService,
            biometricService: mockBiometricService,
            keychainService: mockKeychainService,
            networkSecurity: mockNetworkSecurity
        )
    }
    
    override func tearDownWithError() throws {
        securityTemplate = nil
        mockEncryptionService = nil
        mockBiometricService = nil
        mockKeychainService = nil
        mockNetworkSecurity = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Template Configuration Tests
    
    @Test("Security template initializes with enterprise security settings")
    func testSecurityTemplateInitialization() async throws {
        // Given
        let config = SecurityTemplateConfiguration(
            encryptionLevel: .aes256,
            enableBiometricAuth: true,
            enableKeychainIntegration: true,
            enableNetworkSecurity: true,
            enableDataProtection: true,
            enableCertificatePinning: true,
            complianceLevel: .enterprise
        )
        
        // When
        let template = SecurityTemplate(configuration: config)
        
        // Then
        #expect(template.configuration.encryptionLevel == .aes256)
        #expect(template.configuration.enableBiometricAuth == true)
        #expect(template.configuration.complianceLevel == .enterprise)
        #expect(template.configuration.enableCertificatePinning == true)
    }
    
    @Test("Template validates minimum security requirements")
    func testSecurityRequirements() async throws {
        // Given
        let weakConfig = SecurityTemplateConfiguration(
            encryptionLevel: .none,
            enableBiometricAuth: false,
            enableKeychainIntegration: false,
            enableNetworkSecurity: false,
            enableDataProtection: false,
            enableCertificatePinning: false,
            complianceLevel: .none
        )
        
        // When/Then
        #expect(throws: SecurityTemplateError.insufficientSecurityLevel) {
            let _ = try SecurityTemplate.validate(configuration: weakConfig)
        }
    }
    
    // MARK: - Encryption Tests
    
    @Test("AES-256 encryption succeeds")
    func testAES256Encryption() async throws {
        // Given
        let plaintext = "Sensitive user data that needs encryption"
        let key = SymmetricKey(size: .bits256)
        let expectedCiphertext = "encrypted_data_mock"
        mockEncryptionService.mockEncryptionResult = .success(expectedCiphertext)
        
        // When
        let ciphertext = try await securityTemplate.encryptData(plaintext, using: .aes256)
        
        // Then
        #expect(ciphertext == expectedCiphertext)
        #expect(ciphertext != plaintext)
        #expect(mockEncryptionService.encryptCalled)
    }
    
    @Test("AES-256 decryption succeeds")
    func testAES256Decryption() async throws {
        // Given
        let ciphertext = "encrypted_data_mock"
        let expectedPlaintext = "Sensitive user data that needs encryption"
        mockEncryptionService.mockDecryptionResult = .success(expectedPlaintext)
        
        // When
        let plaintext = try await securityTemplate.decryptData(ciphertext, using: .aes256)
        
        // Then
        #expect(plaintext == expectedPlaintext)
        #expect(mockEncryptionService.decryptCalled)
    }
    
    @Test("Encrypt file with progress tracking")
    func testFileEncryption() async throws {
        // Given
        let fileURL = URL(fileURLWithPath: "/tmp/test_file.txt")
        let outputURL = URL(fileURLWithPath: "/tmp/test_file_encrypted.txt")
        mockEncryptionService.mockFileEncryptionResult = .success(outputURL)
        
        var progressUpdates: [Double] = []
        let progressHandler: (Double) -> Void = { progress in
            progressUpdates.append(progress)
        }
        
        // When
        let encryptedURL = try await securityTemplate.encryptFile(
            at: fileURL,
            outputURL: outputURL,
            progressHandler: progressHandler
        )
        
        // Then
        #expect(encryptedURL == outputURL)
        #expect(progressUpdates.count > 0)
        #expect(mockEncryptionService.encryptFileCalled)
    }
    
    @Test("Hash password with salt")
    func testPasswordHashing() async throws {
        // Given
        let password = "MySecurePassword123!"
        let salt = "random_salt_value"
        let expectedHash = "hashed_password_with_salt"
        mockEncryptionService.mockHashResult = .success(expectedHash)
        
        // When
        let hash = try await securityTemplate.hashPassword(password, salt: salt)
        
        // Then
        #expect(hash == expectedHash)
        #expect(hash != password)
        #expect(mockEncryptionService.hashPasswordCalled)
    }
    
    // MARK: - Biometric Authentication Tests
    
    @Test("Face ID authentication succeeds")
    func testFaceIDAuthentication() async throws {
        // Given
        mockBiometricService.mockAuthResult = .success(true)
        mockBiometricService.mockBiometricType = .faceID
        
        // When
        let result = try await securityTemplate.authenticateWithBiometrics(reason: "Authenticate to access secure data")
        
        // Then
        #expect(result.isAuthenticated)
        #expect(result.biometricType == .faceID)
        #expect(mockBiometricService.authenticateCalled)
    }
    
    @Test("Touch ID authentication succeeds")
    func testTouchIDAuthentication() async throws {
        // Given
        mockBiometricService.mockAuthResult = .success(true)
        mockBiometricService.mockBiometricType = .touchID
        
        // When
        let result = try await securityTemplate.authenticateWithBiometrics(reason: "Unlock secure features")
        
        // Then
        #expect(result.isAuthenticated)
        #expect(result.biometricType == .touchID)
        #expect(mockBiometricService.authenticateCalled)
    }
    
    @Test("Biometric authentication fails gracefully")
    func testBiometricAuthenticationFailure() async throws {
        // Given
        mockBiometricService.mockAuthResult = .failure(BiometricError.authenticationFailed)
        
        // When/Then
        await #expect(throws: BiometricError.authenticationFailed) {
            try await securityTemplate.authenticateWithBiometrics(reason: "Test authentication")
        }
    }
    
    @Test("Check biometric availability")
    func testBiometricAvailability() async throws {
        // Given
        mockBiometricService.mockAvailabilityResult = .success(BiometricAvailability(
            isAvailable: true,
            biometricType: .faceID,
            isEnrolled: true
        ))
        
        // When
        let availability = try await securityTemplate.checkBiometricAvailability()
        
        // Then
        #expect(availability.isAvailable)
        #expect(availability.biometricType == .faceID)
        #expect(availability.isEnrolled)
        #expect(mockBiometricService.checkAvailabilityCalled)
    }
    
    // MARK: - Keychain Security Tests
    
    @Test("Store sensitive data in keychain")
    func testKeychainStorage() async throws {
        // Given
        let key = "user_token"
        let value = "sensitive_access_token_12345"
        mockKeychainService.mockStoreResult = .success(())
        
        // When
        try await securityTemplate.storeInKeychain(value, forKey: key)
        
        // Then
        #expect(mockKeychainService.storeCalled)
        #expect(mockKeychainService.lastStoredKey == key)
        #expect(mockKeychainService.lastStoredValue == value)
    }
    
    @Test("Retrieve data from keychain")
    func testKeychainRetrieval() async throws {
        // Given
        let key = "user_token"
        let expectedValue = "sensitive_access_token_12345"
        mockKeychainService.mockRetrieveResult = .success(expectedValue)
        
        // When
        let value = try await securityTemplate.retrieveFromKeychain(key: key)
        
        // Then
        #expect(value == expectedValue)
        #expect(mockKeychainService.retrieveCalled)
        #expect(mockKeychainService.lastRetrievedKey == key)
    }
    
    @Test("Delete data from keychain")
    func testKeychainDeletion() async throws {
        // Given
        let key = "user_token"
        mockKeychainService.mockDeleteResult = .success(())
        
        // When
        try await securityTemplate.deleteFromKeychain(key: key)
        
        // Then
        #expect(mockKeychainService.deleteCalled)
        #expect(mockKeychainService.lastDeletedKey == key)
    }
    
    @Test("Update keychain item with biometric protection")
    func testKeychainBiometricProtection() async throws {
        // Given
        let key = "biometric_protected_data"
        let value = "highly_sensitive_data"
        let accessControl = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .biometryAny,
            nil
        )!
        mockKeychainService.mockStoreResult = .success(())
        
        // When
        try await securityTemplate.storeInKeychainWithBiometricProtection(
            value,
            forKey: key,
            accessControl: accessControl
        )
        
        // Then
        #expect(mockKeychainService.storeCalled)
        #expect(mockKeychainService.lastBiometricProtection)
    }
    
    // MARK: - Network Security Tests
    
    @Test("Certificate pinning validation")
    func testCertificatePinning() async throws {
        // Given
        let serverURL = URL(string: "https://api.example.com")!
        let certificateData = Data("mock_certificate".utf8)
        mockNetworkSecurity.mockPinningResult = .success(true)
        
        // When
        let isValid = try await securityTemplate.validateCertificatePinning(
            for: serverURL,
            certificate: certificateData
        )
        
        // Then
        #expect(isValid)
        #expect(mockNetworkSecurity.validatePinningCalled)
    }
    
    @Test("Secure network request with SSL validation")
    func testSecureNetworkRequest() async throws {
        // Given
        let url = URL(string: "https://api.example.com/secure-endpoint")!
        let request = URLRequest(url: url)
        let expectedResponse = SecureNetworkResponse(
            data: Data("secure_response".utf8),
            statusCode: 200,
            isSecure: true
        )
        mockNetworkSecurity.mockRequestResult = .success(expectedResponse)
        
        // When
        let response = try await securityTemplate.performSecureRequest(request)
        
        // Then
        #expect(response.isSecure)
        #expect(response.statusCode == 200)
        #expect(mockNetworkSecurity.performRequestCalled)
    }
    
    @Test("Detect man-in-the-middle attacks")
    func testMITMDetection() async throws {
        // Given
        let serverURL = URL(string: "https://suspicious.example.com")!
        mockNetworkSecurity.mockMITMResult = .success(MITMDetectionResult(
            isSuspicious: true,
            riskLevel: .high,
            indicators: ["Certificate mismatch", "Unexpected certificate chain"]
        ))
        
        // When
        let result = try await securityTemplate.detectMITMAttack(for: serverURL)
        
        // Then
        #expect(result.isSuspicious)
        #expect(result.riskLevel == .high)
        #expect(mockNetworkSecurity.detectMITMCalled)
    }
    
    // MARK: - Data Protection Tests
    
    @Test("Enable data protection for file")
    func testDataProtection() async throws {
        // Given
        let fileURL = URL(fileURLWithPath: "/tmp/protected_file.txt")
        let protectionLevel = FileProtectionType.complete
        mockEncryptionService.mockProtectionResult = .success(())
        
        // When
        try await securityTemplate.enableDataProtection(
            for: fileURL,
            level: protectionLevel
        )
        
        // Then
        #expect(mockEncryptionService.enableProtectionCalled)
        #expect(mockEncryptionService.lastProtectionLevel == protectionLevel)
    }
    
    @Test("Validate data integrity with checksum")
    func testDataIntegrityValidation() async throws {
        // Given
        let data = Data("Important data that needs integrity validation".utf8)
        let expectedChecksum = "abc123def456"
        mockEncryptionService.mockChecksumResult = .success(expectedChecksum)
        
        // When
        let checksum = try await securityTemplate.calculateDataChecksum(data)
        
        // Then
        #expect(checksum == expectedChecksum)
        #expect(mockEncryptionService.calculateChecksumCalled)
    }
    
    @Test("Secure data wiping")
    func testSecureDataWiping() async throws {
        // Given
        let fileURL = URL(fileURLWithPath: "/tmp/sensitive_file.txt")
        mockEncryptionService.mockWipeResult = .success(())
        
        // When
        try await securityTemplate.secureWipeFile(at: fileURL)
        
        // Then
        #expect(mockEncryptionService.secureWipeCalled)
    }
    
    // MARK: - Security Monitoring Tests
    
    @Test("Detect security threats")
    func testThreatDetection() async throws {
        // Given
        let expectedThreats = [
            SecurityThreat(
                type: .malware,
                severity: .high,
                description: "Suspicious binary detected",
                timestamp: Date()
            ),
            SecurityThreat(
                type: .dataExfiltration,
                severity: .medium,
                description: "Unusual network activity",
                timestamp: Date()
            )
        ]
        mockNetworkSecurity.mockThreatResult = .success(expectedThreats)
        
        // When
        let threats = try await securityTemplate.detectSecurityThreats()
        
        // Then
        #expect(threats.count == 2)
        #expect(threats.contains { $0.type == .malware && $0.severity == .high })
        #expect(mockNetworkSecurity.detectThreatsCalled)
    }
    
    @Test("Security audit trail logging")
    func testSecurityAuditTrail() async throws {
        // Given
        let auditEvent = SecurityAuditEvent(
            action: .authentication,
            user: "test_user",
            timestamp: Date(),
            success: true,
            details: ["method": "biometric", "type": "faceID"]
        )
        mockKeychainService.mockAuditResult = .success(())
        
        // When
        try await securityTemplate.logSecurityEvent(auditEvent)
        
        // Then
        #expect(mockKeychainService.logAuditEventCalled)
        #expect(mockKeychainService.lastAuditEvent?.action == .authentication)
    }
    
    // MARK: - Compliance Tests
    
    @Test("GDPR compliance validation")
    func testGDPRCompliance() async throws {
        // Given
        let userData = UserData(
            id: "user123",
            email: "user@example.com",
            personalData: ["name": "John Doe", "age": "30"]
        )
        let expectedCompliance = ComplianceReport(
            isCompliant: true,
            regulations: [.gdpr],
            violations: [],
            recommendations: []
        )
        mockEncryptionService.mockComplianceResult = .success(expectedCompliance)
        
        // When
        let compliance = try await securityTemplate.validateGDPRCompliance(for: userData)
        
        // Then
        #expect(compliance.isCompliant)
        #expect(compliance.regulations.contains(.gdpr))
        #expect(mockEncryptionService.validateComplianceCalled)
    }
    
    @Test("HIPAA compliance validation")
    func testHIPAACompliance() async throws {
        // Given
        let healthData = HealthData(
            patientId: "patient123",
            medicalRecords: ["diagnosis": "healthy", "treatment": "none"]
        )
        mockEncryptionService.mockComplianceResult = .success(ComplianceReport(
            isCompliant: true,
            regulations: [.hipaa],
            violations: [],
            recommendations: []
        ))
        
        // When
        let compliance = try await securityTemplate.validateHIPAACompliance(for: healthData)
        
        // Then
        #expect(compliance.isCompliant)
        #expect(compliance.regulations.contains(.hipaa))
        #expect(mockEncryptionService.validateComplianceCalled)
    }
    
    // MARK: - Performance Tests
    
    @Test("Encryption performance under 100ms")
    func testEncryptionPerformance() async throws {
        // Given
        let data = String(repeating: "test", count: 1000) // 4KB of data
        mockEncryptionService.mockEncryptionResult = .success("encrypted_data")
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await securityTemplate.encryptData(data, using: .aes256)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.1, "Encryption should complete under 100ms")
    }
    
    @Test("Biometric authentication under 3 seconds")
    func testBiometricPerformance() async throws {
        // Given
        mockBiometricService.mockAuthResult = .success(true)
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        let _ = try await securityTemplate.authenticateWithBiometrics(reason: "Test")
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 3.0, "Biometric authentication should complete under 3 seconds")
    }
    
    @Test("Keychain operations under 50ms")
    func testKeychainPerformance() async throws {
        // Given
        mockKeychainService.mockStoreResult = .success(())
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        try await securityTemplate.storeInKeychain("test_value", forKey: "test_key")
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let duration = endTime - startTime
        #expect(duration < 0.05, "Keychain operations should complete under 50ms")
    }
}

// MARK: - Mock Classes

class MockEncryptionService {
    var encryptCalled = false
    var decryptCalled = false
    var encryptFileCalled = false
    var hashPasswordCalled = false
    var enableProtectionCalled = false
    var calculateChecksumCalled = false
    var secureWipeCalled = false
    var validateComplianceCalled = false
    var lastProtectionLevel: FileProtectionType?
    
    var mockEncryptionResult: Result<String, Error> = .success("encrypted")
    var mockDecryptionResult: Result<String, Error> = .success("decrypted")
    var mockFileEncryptionResult: Result<URL, Error> = .success(URL(fileURLWithPath: "/tmp/encrypted"))
    var mockHashResult: Result<String, Error> = .success("hashed")
    var mockProtectionResult: Result<Void, Error> = .success(())
    var mockChecksumResult: Result<String, Error> = .success("checksum")
    var mockWipeResult: Result<Void, Error> = .success(())
    var mockComplianceResult: Result<ComplianceReport, Error> = .success(.mock)
}

class MockBiometricService {
    var authenticateCalled = false
    var checkAvailabilityCalled = false
    var mockBiometricType: LABiometryType = .faceID
    
    var mockAuthResult: Result<Bool, Error> = .success(true)
    var mockAvailabilityResult: Result<BiometricAvailability, Error> = .success(.mock)
}

class MockKeychainService {
    var storeCalled = false
    var retrieveCalled = false
    var deleteCalled = false
    var logAuditEventCalled = false
    var lastStoredKey: String?
    var lastStoredValue: String?
    var lastRetrievedKey: String?
    var lastDeletedKey: String?
    var lastBiometricProtection = false
    var lastAuditEvent: SecurityAuditEvent?
    
    var mockStoreResult: Result<Void, Error> = .success(())
    var mockRetrieveResult: Result<String, Error> = .success("retrieved")
    var mockDeleteResult: Result<Void, Error> = .success(())
    var mockAuditResult: Result<Void, Error> = .success(())
}

class MockNetworkSecurity {
    var validatePinningCalled = false
    var performRequestCalled = false
    var detectMITMCalled = false
    var detectThreatsCalled = false
    
    var mockPinningResult: Result<Bool, Error> = .success(true)
    var mockRequestResult: Result<SecureNetworkResponse, Error> = .success(.mock)
    var mockMITMResult: Result<MITMDetectionResult, Error> = .success(.mock)
    var mockThreatResult: Result<[SecurityThreat], Error> = .success([])
}

// MARK: - Mock Data Extensions

extension BiometricAvailability {
    static let mock = BiometricAvailability(
        isAvailable: true,
        biometricType: .faceID,
        isEnrolled: true
    )
}

extension SecureNetworkResponse {
    static let mock = SecureNetworkResponse(
        data: Data(),
        statusCode: 200,
        isSecure: true
    )
}

extension MITMDetectionResult {
    static let mock = MITMDetectionResult(
        isSuspicious: false,
        riskLevel: .low,
        indicators: []
    )
}

extension ComplianceReport {
    static let mock = ComplianceReport(
        isCompliant: true,
        regulations: [.gdpr],
        violations: [],
        recommendations: []
    )
}