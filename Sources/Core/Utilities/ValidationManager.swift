//
//  ValidationManager.swift
//  iOSAppTemplates
//
//  Created by Muhittin Camdali on 17/08/2024.
//

import Foundation

/// Centralized validation manager for input validation across the app
public final class ValidationManager {
    public static let shared = ValidationManager()
    
    private init() {}
    
    // MARK: - Email Validation
    
    public func validateEmail(_ email: String) -> ValidationResult {
        guard !email.isEmpty else {
            return .failure(.emptyField)
        }
        
        guard email.isValidEmail else {
            return .failure(.invalidEmail)
        }
        
        return .success
    }
    
    // MARK: - Password Validation
    
    public func validatePassword(_ password: String) -> ValidationResult {
        guard !password.isEmpty else {
            return .failure(.emptyField)
        }
        
        guard password.count >= 8 else {
            return .failure(.passwordTooShort)
        }
        
        guard password.range(of: #"[A-Z]"#, options: .regularExpression) != nil else {
            return .failure(.passwordMissingUppercase)
        }
        
        guard password.range(of: #"[a-z]"#, options: .regularExpression) != nil else {
            return .failure(.passwordMissingLowercase)
        }
        
        guard password.range(of: #"[0-9]"#, options: .regularExpression) != nil else {
            return .failure(.passwordMissingNumber)
        }
        
        guard password.range(of: #"[!@#$%^&*(),.?\":{}|<>]"#, options: .regularExpression) != nil else {
            return .failure(.passwordMissingSpecialChar)
        }
        
        return .success
    }
    
    // MARK: - Phone Number Validation
    
    public func validatePhoneNumber(_ phoneNumber: String) -> ValidationResult {
        guard !phoneNumber.isEmpty else {
            return .failure(.emptyField)
        }
        
        let phoneRegex = #"^[\+]?[1-9][\d]{0,15}$"#
        guard phoneNumber.range(of: phoneRegex, options: .regularExpression) != nil else {
            return .failure(.invalidPhoneNumber)
        }
        
        return .success
    }
    
    // MARK: - Name Validation
    
    public func validateName(_ name: String) -> ValidationResult {
        guard !name.trimmed.isEmpty else {
            return .failure(.emptyField)
        }
        
        guard name.trimmed.count >= 2 else {
            return .failure(.nameTooShort)
        }
        
        guard name.trimmed.count <= 50 else {
            return .failure(.nameTooLong)
        }
        
        let nameRegex = #"^[a-zA-ZÀ-ÿ\s'-]+$"#
        guard name.range(of: nameRegex, options: .regularExpression) != nil else {
            return .failure(.invalidName)
        }
        
        return .success
    }
}

// MARK: - Validation Result

public enum ValidationResult {
    case success
    case failure(ValidationError)
    
    public var isValid: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var errorMessage: String? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error.localizedDescription
        }
    }
}

// MARK: - Validation Errors

public enum ValidationError: LocalizedError {
    case emptyField
    case invalidEmail
    case passwordTooShort
    case passwordMissingUppercase
    case passwordMissingLowercase
    case passwordMissingNumber
    case passwordMissingSpecialChar
    case invalidPhoneNumber
    case nameTooShort
    case nameTooLong
    case invalidName
    
    public var errorDescription: String? {
        switch self {
        case .emptyField:
            return "This field is required"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .passwordTooShort:
            return "Password must be at least 8 characters long"
        case .passwordMissingUppercase:
            return "Password must contain at least one uppercase letter"
        case .passwordMissingLowercase:
            return "Password must contain at least one lowercase letter"
        case .passwordMissingNumber:
            return "Password must contain at least one number"
        case .passwordMissingSpecialChar:
            return "Password must contain at least one special character"
        case .invalidPhoneNumber:
            return "Please enter a valid phone number"
        case .nameTooShort:
            return "Name must be at least 2 characters long"
        case .nameTooLong:
            return "Name cannot exceed 50 characters"
        case .invalidName:
            return "Name contains invalid characters"
        }
    }
}