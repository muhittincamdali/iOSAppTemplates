# Security API

Bu sayfa repo icindeki security-related source surface'i ozetler. Bu alan yararli reference code icerir; tek basina audited security proof sayilmaz.

Canonical kaynak:

- `Sources/SecurityTemplates/SecureAppTemplate.swift`

## Current Surface

Bugun dokumante edilmeye deger public tipler:

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

Bu tip bir umbrella entry olarak durur; asil davranis manager ve helper tiplerindedir.

## BiometricAuthManager

`LocalAuthentication` uzerinden biometric availability ve login-style auth helper'i sunar.

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

Keychain-backed basit storage helper:

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

`CryptoKit` tabanli simetrik encryption helper'i:

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

`Alamofire` uzerinden stricter request setup ornegi sunar.

Current truth:
- secure headers ekler
- trusted host allowlist kullanir
- stricter TLS/session config uygular
- pinned certificate evaluator setup'i gosterir

Bu surface bir reference implementation'dir. Gercek production setup'ta:
- kendi host listeni
- kendi certificate strategy'ni
- kendi threat model'ini
ayri dogrulaman gerekir.

## DataValidator

Input validation helper surface'i de ayni kaynak dosyada yer alir. Form/data acceptance kurallarini merkezi tutmak icin referans olarak kullanilabilir.

## What This Page Does Not Claim

Bu dokuman su garantileri vermez:

- audited security certification
- immutable zero-trust posture
- store review approval
- end-to-end secure production deployment

Bugunku dogru claim:
- repo icinde kullanisli security reference code var
- ama bunu shipping proof ile karistirmamak gerekir

## Related Reading

1. [Template Guide](./TemplateGuide.md)
2. [Architecture API](./ArchitectureAPI.md)
3. [Complete App Standard](./Complete-App-Standard.md)
