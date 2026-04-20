# Security API

This page summarizes the security-related source surface in the repo. It contains useful reference code, but it should not be treated as audited security proof on its own.

Canonical source:

- `Sources/SecurityTemplates/SecureAppTemplate.swift`

## Current Surface

Public types worth documenting today:

- `SecureAppTemplate`
- `BiometricAuthManager`
- `SecureStorageManager`
- `EncryptionManager`
- `SecureNetworkManager`
- `DataValidator`

## SecureAppTemplate

```swift
public struct SecureAppTemplate {
    public init()
}
```

This type acts as an umbrella entry point. Most behavior lives in the managers and helper types.

## BiometricAuthManager

Provides biometric-availability and login-style authentication helpers on top of `LocalAuthentication`.

```swift
@Observable
public class BiometricAuthManager {
    public var isAuthenticated: Bool
    public var biometricType: LABiometryType
    public var canUseBiometrics: Bool
    public var authenticationError: String?

    public init()
    public func checkBiometricAvailability()
    @MainActor public func authenticate(reason: String = ...) async -> Bool
    public func logout()
}
```

## SecureStorageManager

Simple Keychain-backed storage helper:

```swift
@MainActor
public class SecureStorageManager {
    public static let shared: SecureStorageManager

    public func store(_ data: Data, for key: String) throws
    public func retrieve(for key: String) throws -> Data?
    public func delete(for key: String) throws
    public func storeString(_ string: String, for key: String) throws
    public func retrieveString(for key: String) throws -> String?
}
```

## EncryptionManager

`CryptoKit`-based symmetric-encryption helper:

```swift
@MainActor
public class EncryptionManager {
    public static let shared: EncryptionManager

    public func generateKey() -> SymmetricKey
    public func encrypt(_ data: Data, with key: SymmetricKey) throws -> Data
    public func decrypt(_ encryptedData: Data, with key: SymmetricKey) throws -> Data
    public func encryptString(_ string: String, with key: SymmetricKey) throws -> Data
    public func decryptString(_ encryptedData: Data, with key: SymmetricKey) throws -> String
    public func hash(_ data: Data) -> Data
    public func hashString(_ string: String) -> String?
}
```

## SecureNetworkManager

Provides a stricter request-setup example on top of `Alamofire`.

Current truth:
- adds secure headers
- uses a trusted-host allowlist
- applies stricter TLS and session configuration
- shows a pinned-certificate evaluator setup

This surface is a reference implementation. In a real production setup you still need to validate separately:
- your own host list
- your own certificate strategy
- your own threat model

## DataValidator

The same source file also contains an input-validation helper surface. It can be used as a reference for centralizing form and data-acceptance rules.

## What This Page Does Not Claim

This document does not claim:

- audited security certification
- an immutable zero-trust posture
- store-review approval
- end-to-end secure production deployment

Current truthful claim:
- the repo contains useful security reference code
- it should not be confused with shipping proof

## Related Reading

1. [Template Guide](./TemplateGuide.md)
2. [Architecture API](./ArchitectureAPI.md)
3. [Complete App Standard](./Complete-App-Standard.md)
