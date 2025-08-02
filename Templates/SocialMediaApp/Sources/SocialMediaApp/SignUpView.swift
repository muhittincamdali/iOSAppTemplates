import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Join our community today")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        CustomTextField(
                            text: $name,
                            placeholder: "Full Name",
                            icon: "person"
                        )
                        
                        CustomTextField(
                            text: $email,
                            placeholder: "Email Address",
                            icon: "envelope",
                            validation: .email
                        )
                        
                        CustomTextField(
                            text: $password,
                            placeholder: "Password",
                            icon: "lock",
                            validation: .password,
                            isSecure: true
                        )
                        
                        CustomTextField(
                            text: $confirmPassword,
                            placeholder: "Confirm Password",
                            icon: "lock",
                            validation: .password,
                            isSecure: true
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Sign Up Button
                    Button(action: signUp) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Create Account")
                                    .font(.headline)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(10)
                    }
                    .disabled(!isFormValid || isLoading)
                    .padding(.horizontal, 20)
                    
                    // Terms and Conditions
                    VStack(spacing: 8) {
                        Text("By creating an account, you agree to our")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 4) {
                            Button("Terms of Service") {
                                // Handle terms tap
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                            
                            Text("and")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Button("Privacy Policy") {
                                // Handle privacy tap
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    // Sign In Link
                    HStack {
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Button("Sign In") {
                            dismiss()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .alert("Sign Up Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword &&
        password.count >= 8 &&
        email.contains("@")
    }
    
    @State private var isLoading = false
    
    // MARK: - Methods
    private func signUp() {
        guard isFormValid else {
            alertMessage = "Please fill in all fields correctly"
            showingAlert = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await AuthManager.shared.signUp(email: email, password: password, name: name)
                await MainActor.run {
                    isLoading = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
}

// MARK: - Custom Text Field
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    let validation: TextFieldValidation
    let isSecure: Bool
    
    init(
        text: Binding<String>,
        placeholder: String,
        icon: String,
        validation: TextFieldValidation = .none,
        isSecure: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.validation = validation
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
                    .frame(width: 20)
                
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if !text.isEmpty {
                validationMessage
            }
        }
    }
    
    @ViewBuilder
    private var validationMessage: some View {
        switch validation {
        case .email:
            if !text.isValidEmail {
                Text("Please enter a valid email address")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        case .password:
            if text.count < 8 {
                Text("Password must be at least 8 characters")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        default:
            EmptyView()
        }
    }
}

// MARK: - Text Field Validation
enum TextFieldValidation {
    case none
    case email
    case password
    case phone
    case custom
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
} 