import SwiftUI
import LocalAuthentication
import CryptoKit
import Alamofire
import FirebaseAuth
import Foundation
import Security

// MARK: - Secure App Template

/// Enterprise-grade security template with advanced protection
/// Features: Biometric auth, encryption, secure storage, network security
public struct SecureAppTemplate {
    public init() {}
}

// MARK: - Biometric Authentication Manager

@Observable
public class BiometricAuthManager {
    public var isAuthenticated = false
    public var biometricType: LABiometryType = .none
    public var canUseBiometrics = false
    public var authenticationError: String?
    
    private let context = LAContext()
    
    public init() {
        checkBiometricAvailability()
    }
    
    public func checkBiometricAvailability() {
        var error: NSError?
        canUseBiometrics = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        biometricType = context.biometryType
        
        if let error = error {
            authenticationError = error.localizedDescription
        }
    }
    
    @MainActor
    public func authenticate(reason: String = "Authenticate to access your account") async -> Bool {
        guard canUseBiometrics else {
            authenticationError = "Biometric authentication not available"
            return false
        }
        
        do {
            let result = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            
            isAuthenticated = result
            authenticationError = nil
            return result
        } catch {
            authenticationError = error.localizedDescription
            isAuthenticated = false
            return false
        }
    }
    
    public func logout() {
        isAuthenticated = false
    }
}

// MARK: - Secure Storage Manager

public class SecureStorageManager {
    private let service = "com.app.secure.storage"
    
    public static let shared = SecureStorageManager()
    
    private init() {}
    
    public func store(_ data: Data, for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // Delete existing item
        SecItemDelete(query as CFDictionary)
        
        // Add new item
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw SecureStorageError.storageError(status)
        }
    }
    
    public func retrieve(for key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                return nil
            }
            throw SecureStorageError.retrievalError(status)
        }
        
        return item as? Data
    }
    
    public func delete(for key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw SecureStorageError.deletionError(status)
        }
    }
    
    public func storeString(_ string: String, for key: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw SecureStorageError.encodingError
        }
        try store(data, for: key)
    }
    
    public func retrieveString(for key: String) throws -> String? {
        guard let data = try retrieve(for: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: - Encryption Manager

public class EncryptionManager {
    public static let shared = EncryptionManager()
    
    private init() {}
    
    public func generateKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }
    
    public func encrypt(_ data: Data, with key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }
    
    public func decrypt(_ encryptedData: Data, with key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    public func encryptString(_ string: String, with key: SymmetricKey) throws -> Data {
        guard let data = string.data(using: .utf8) else {
            throw EncryptionError.encodingError
        }
        return try encrypt(data, with: key)
    }
    
    public func decryptString(_ encryptedData: Data, with key: SymmetricKey) throws -> String {
        let decryptedData = try decrypt(encryptedData, with: key)
        guard let string = String(data: decryptedData, encoding: .utf8) else {
            throw EncryptionError.decodingError
        }
        return string
    }
    
    public func hash(_ data: Data) -> Data {
        return Data(SHA256.hash(data: data))
    }
    
    public func hashString(_ string: String) -> String? {
        guard let data = string.data(using: .utf8) else { return nil }
        return hash(data).base64EncodedString()
    }
}

// MARK: - Secure Network Manager

public class SecureNetworkManager {
    public static let shared = SecureNetworkManager()
    
    private let session: Session
    private let trustedHosts: Set<String>
    
    private init() {
        // Configure secure session
        let configuration = URLSessionConfiguration.default
        configuration.tlsMinimumSupportedProtocolVersion = .TLSv13
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        
        // Certificate pinning
        let evaluator = PinnedCertificatesTrustEvaluator(
            certificates: [],
            acceptSelfSignedCertificates: false,
            performDefaultValidation: true,
            validateHost: true
        )
        
        let serverTrustManager = ServerTrustManager(evaluators: [
            "api.example.com": evaluator
        ])
        
        self.session = Session(
            configuration: configuration,
            serverTrustManager: serverTrustManager
        )
        
        self.trustedHosts = ["api.example.com", "secure.example.com"]
    }
    
    public func secureRequest<T: Decodable>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) async throws -> T {
        // Validate URL
        guard let urlString = try? url.asURL().absoluteString,
              let host = URL(string: urlString)?.host,
              trustedHosts.contains(host) else {
            throw NetworkError.untrustedHost
        }
        
        // Add security headers
        var secureHeaders = headers ?? HTTPHeaders()
        secureHeaders["X-Requested-With"] = "XMLHttpRequest"
        secureHeaders["X-Content-Type-Options"] = "nosniff"
        secureHeaders["X-Frame-Options"] = "DENY"
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                headers: secureHeaders
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Data Validation

public struct DataValidator {
    public static func validateEmail(_ email: String) -> Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    public static func validatePassword(_ password: String) -> PasswordValidationResult {
        var issues: [PasswordIssue] = []
        
        if password.count < 8 {
            issues.append(.tooShort)
        }
        
        if !password.contains(where: { $0.isUppercase }) {
            issues.append(.missingUppercase)
        }
        
        if !password.contains(where: { $0.isLowercase }) {
            issues.append(.missingLowercase)
        }
        
        if !password.contains(where: { $0.isNumber }) {
            issues.append(.missingNumber)
        }
        
        if !password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }) {
            issues.append(.missingSpecialCharacter)
        }
        
        return PasswordValidationResult(issues: issues)
    }
    
    public static func sanitizeInput(_ input: String) -> String {
        return input
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#x27;")
    }
}

// MARK: - Security Demo View

public struct SecurityDemoView: View {
    @State private var biometricManager = BiometricAuthManager()
    @State private var isShowingSecureArea = false
    @State private var email = ""
    @State private var password = ""
    @State private var encryptedText = ""
    @State private var decryptedText = ""
    @State private var encryptionKey = EncryptionManager.shared.generateKey()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Authentication Section
                    BiometricAuthSection(manager: biometricManager)
                    
                    // Secure Storage Section
                    SecureStorageSection()
                    
                    // Encryption Section
                    EncryptionSection(
                        encryptedText: $encryptedText,
                        decryptedText: $decryptedText,
                        encryptionKey: encryptionKey
                    )
                    
                    // Data Validation Section
                    DataValidationSection(email: $email, password: $password)
                }
                .padding()
            }
            .navigationTitle("Security Demo")
        }
    }
}

// MARK: - Biometric Auth Section

public struct BiometricAuthSection: View {
    @Bindable var manager: BiometricAuthManager
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Biometric Authentication")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: biometricIcon)
                        .foregroundStyle(.blue)
                    Text("Biometric Type: \(biometricTypeText)")
                    Spacer()
                    Circle()
                        .fill(manager.canUseBiometrics ? .green : .red)
                        .frame(width: 8, height: 8)
                }
                
                if let error = manager.authenticationError {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            
            Button(manager.isAuthenticated ? "Logout" : "Authenticate") {
                if manager.isAuthenticated {
                    manager.logout()
                } else {
                    Task {
                        await manager.authenticate()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!manager.canUseBiometrics)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var biometricIcon: String {
        switch manager.biometricType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        default:
            return "lock"
        }
    }
    
    private var biometricTypeText: String {
        switch manager.biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        default:
            return "None"
        }
    }
}

// MARK: - Secure Storage Section

public struct SecureStorageSection: View {
    @State private var inputText = ""
    @State private var storedText = ""
    @State private var statusMessage = ""
    
    private let storageKey = "demo_secure_data"
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Secure Storage")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("Enter text to store securely", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Button("Store") {
                        storeData()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Retrieve") {
                        retrieveData()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Delete") {
                        deleteData()
                    }
                    .buttonStyle(.bordered)
                }
                
                if !storedText.isEmpty {
                    Text("Retrieved: \(storedText)")
                        .font(.caption)
                        .padding(8)
                        .background(.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                if !statusMessage.isEmpty {
                    Text(statusMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func storeData() {
        do {
            try SecureStorageManager.shared.storeString(inputText, for: storageKey)
            statusMessage = "Data stored securely"
        } catch {
            statusMessage = "Storage failed: \(error.localizedDescription)"
        }
    }
    
    private func retrieveData() {
        do {
            storedText = try SecureStorageManager.shared.retrieveString(for: storageKey) ?? "No data found"
            statusMessage = "Data retrieved successfully"
        } catch {
            statusMessage = "Retrieval failed: \(error.localizedDescription)"
        }
    }
    
    private func deleteData() {
        do {
            try SecureStorageManager.shared.delete(for: storageKey)
            storedText = ""
            statusMessage = "Data deleted successfully"
        } catch {
            statusMessage = "Deletion failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - Encryption Section

public struct EncryptionSection: View {
    @State private var plainText = ""
    @Binding var encryptedText: String
    @Binding var decryptedText: String
    let encryptionKey: SymmetricKey
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AES-256 Encryption")
                .font(.headline)
            
            VStack(spacing: 12) {
                TextField("Enter text to encrypt", text: $plainText)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Button("Encrypt") {
                        encryptData()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Decrypt") {
                        decryptData()
                    }
                    .buttonStyle(.bordered)
                    .disabled(encryptedText.isEmpty)
                }
                
                if !encryptedText.isEmpty {
                    Text("Encrypted (Base64): \(encryptedText)")
                        .font(.caption)
                        .lineLimit(3)
                        .padding(8)
                        .background(.orange.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                if !decryptedText.isEmpty {
                    Text("Decrypted: \(decryptedText)")
                        .font(.caption)
                        .padding(8)
                        .background(.green.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func encryptData() {
        do {
            let encrypted = try EncryptionManager.shared.encryptString(plainText, with: encryptionKey)
            encryptedText = encrypted.base64EncodedString()
        } catch {
            encryptedText = "Encryption failed: \(error.localizedDescription)"
        }
    }
    
    private func decryptData() {
        do {
            guard let data = Data(base64Encoded: encryptedText) else {
                decryptedText = "Invalid base64 data"
                return
            }
            decryptedText = try EncryptionManager.shared.decryptString(data, with: encryptionKey)
        } catch {
            decryptedText = "Decryption failed: \(error.localizedDescription)"
        }
    }
}

// MARK: - Data Validation Section

public struct DataValidationSection: View {
    @Binding var email: String
    @Binding var password: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Data Validation")
                .font(.headline)
            
            VStack(spacing: 12) {
                HStack {
                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                    
                    Image(systemName: DataValidator.validateEmail(email) ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(DataValidator.validateEmail(email) ? .green : .red)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                    let validation = DataValidator.validatePassword(password)
                    ForEach(validation.issues, id: \.self) { issue in
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                                .font(.caption)
                            Text(issue.description)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                    }
                    
                    if validation.isValid {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.caption)
                            Text("Password meets all requirements")
                                .font(.caption)
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Error Types

public enum SecureStorageError: Error {
    case storageError(OSStatus)
    case retrievalError(OSStatus)
    case deletionError(OSStatus)
    case encodingError
}

public enum EncryptionError: Error {
    case encodingError
    case decodingError
}

public enum NetworkError: Error {
    case untrustedHost
    case invalidResponse
    case securityViolation
}

// MARK: - Password Validation

public struct PasswordValidationResult {
    public let issues: [PasswordIssue]
    
    public var isValid: Bool {
        return issues.isEmpty
    }
}

public enum PasswordIssue: CaseIterable {
    case tooShort
    case missingUppercase
    case missingLowercase
    case missingNumber
    case missingSpecialCharacter
    
    public var description: String {
        switch self {
        case .tooShort:
            return "Password must be at least 8 characters"
        case .missingUppercase:
            return "Password must contain uppercase letter"
        case .missingLowercase:
            return "Password must contain lowercase letter"
        case .missingNumber:
            return "Password must contain number"
        case .missingSpecialCharacter:
            return "Password must contain special character"
        }
    }
}

extension PasswordIssue: Hashable {}