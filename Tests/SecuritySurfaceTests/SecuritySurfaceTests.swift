import XCTest
@testable import SecurityTemplates

@MainActor
final class SecuritySurfaceTests: XCTestCase {
    func testSecureAppTemplateInitializes() {
        let template = SecureAppTemplate()
        XCTAssertNotNil(template)
    }

    func testBiometricAuthManagerInitializesWithKnownDefaults() {
        let manager = BiometricAuthManager()

        XCTAssertFalse(manager.isAuthenticated)
        if manager.canUseBiometrics {
            XCTAssertNotEqual(manager.biometricType, .none)
        }
    }

    func testEncryptionManagerRoundTrip() throws {
        let key = EncryptionManager.shared.generateKey()
        let encrypted = try EncryptionManager.shared.encryptString("secret-value", with: key)
        let decrypted = try EncryptionManager.shared.decryptString(encrypted, with: key)

        XCTAssertEqual(decrypted, "secret-value")
    }

    func testEmailValidationAcceptsCommonAddress() {
        XCTAssertTrue(DataValidator.validateEmail("hello@example.com"))
        XCTAssertFalse(DataValidator.validateEmail("not-an-email"))
    }

    func testPasswordValidationReportsExpectedIssues() {
        let weakResult = DataValidator.validatePassword("short")
        let strongResult = DataValidator.validatePassword("StrongPass1!")

        XCTAssertFalse(weakResult.isValid)
        XCTAssertTrue(weakResult.issues.contains(.tooShort))
        XCTAssertTrue(weakResult.issues.contains(.missingUppercase))
        XCTAssertTrue(strongResult.isValid)
    }

    func testInputSanitizationEscapesMarkupCharacters() {
        let sanitized = DataValidator.sanitizeInput(#"<script>alert('x')</script>"#)

        XCTAssertFalse(sanitized.contains("<script>"))
        XCTAssertTrue(sanitized.contains("&amp;lt;"))
        XCTAssertTrue(sanitized.contains("&#x27;"))
    }

    func testNetworkErrorCasesStayStable() {
        XCTAssertEqual(String(describing: NetworkError.untrustedHost), "untrustedHost")
        XCTAssertEqual(String(describing: NetworkError.invalidResponse), "invalidResponse")
    }
}
