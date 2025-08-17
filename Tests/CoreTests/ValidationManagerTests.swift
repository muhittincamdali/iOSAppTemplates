//
//  ValidationManagerTests.swift
//  iOSAppTemplatesTests
//
//  Created by Muhittin Camdali on 17/08/2024.
//

import XCTest
@testable import iOSAppTemplates

final class ValidationManagerTests: XCTestCase {
    
    var validationManager: ValidationManager!
    
    override func setUpWithError() throws {
        validationManager = ValidationManager.shared
    }
    
    override func tearDownWithError() throws {
        validationManager = nil
    }
    
    // MARK: - Email Validation Tests
    
    func testValidEmailAddresses() {
        let validEmails = [
            "test@example.com",
            "user.name@domain.co.uk",
            "firstname+lastname@example.com",
            "email@123.123.123.123",
            "1234567890@example.com"
        ]
        
        for email in validEmails {
            let result = validationManager.validateEmail(email)
            XCTAssertTrue(result.isValid, "Email \(email) should be valid")
        }
    }
    
    func testInvalidEmailAddresses() {
        let invalidEmails = [
            "",
            "plainaddress",
            "@missingdomain.com",
            "missing@.com",
            "missing.domain@.com",
            "spaces in@email.com"
        ]
        
        for email in invalidEmails {
            let result = validationManager.validateEmail(email)
            XCTAssertFalse(result.isValid, "Email \(email) should be invalid")
        }
    }
    
    // MARK: - Password Validation Tests
    
    func testValidPasswords() {
        let validPasswords = [
            "SecurePass123!",
            "MyPassword1@",
            "Complex#Pass99",
            "StrongPwd$456"
        ]
        
        for password in validPasswords {
            let result = validationManager.validatePassword(password)
            XCTAssertTrue(result.isValid, "Password \(password) should be valid")
        }
    }
    
    func testInvalidPasswords() {
        let invalidPasswords = [
            "",
            "short",
            "nouppercase123!",
            "NOLOWERCASE123!",
            "NoNumbers!",
            "NoSpecialChars123"
        ]
        
        for password in invalidPasswords {
            let result = validationManager.validatePassword(password)
            XCTAssertFalse(result.isValid, "Password \(password) should be invalid")
        }
    }
    
    // MARK: - Phone Number Validation Tests
    
    func testValidPhoneNumbers() {
        let validPhones = [
            "+1234567890",
            "1234567890",
            "+905551234567",
            "5551234567"
        ]
        
        for phone in validPhones {
            let result = validationManager.validatePhoneNumber(phone)
            XCTAssertTrue(result.isValid, "Phone \(phone) should be valid")
        }
    }
    
    func testInvalidPhoneNumbers() {
        let invalidPhones = [
            "",
            "abc123",
            "+",
            "12345678901234567890" // Too long
        ]
        
        for phone in invalidPhones {
            let result = validationManager.validatePhoneNumber(phone)
            XCTAssertFalse(result.isValid, "Phone \(phone) should be invalid")
        }
    }
    
    // MARK: - Name Validation Tests
    
    func testValidNames() {
        let validNames = [
            "John Doe",
            "Mary Jane",
            "José González",
            "O'Connor",
            "Jean-Pierre"
        ]
        
        for name in validNames {
            let result = validationManager.validateName(name)
            XCTAssertTrue(result.isValid, "Name \(name) should be valid")
        }
    }
    
    func testInvalidNames() {
        let invalidNames = [
            "",
            "A",
            "John123",
            "Name@WithSymbols",
            String(repeating: "A", count: 51) // Too long
        ]
        
        for name in invalidNames {
            let result = validationManager.validateName(name)
            XCTAssertFalse(result.isValid, "Name \(name) should be invalid")
        }
    }
    
    // MARK: - Error Message Tests
    
    func testEmptyFieldErrorMessage() {
        let result = validationManager.validateEmail("")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "This field is required")
    }
    
    func testInvalidEmailErrorMessage() {
        let result = validationManager.validateEmail("invalid-email")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Please enter a valid email address")
    }
    
    func testPasswordTooShortErrorMessage() {
        let result = validationManager.validatePassword("short")
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(result.errorMessage, "Password must be at least 8 characters long")
    }
}