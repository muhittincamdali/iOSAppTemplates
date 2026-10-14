import Foundation
import SwiftUI

struct SplashView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App logo
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0)) {
                            logoScale = 1.0
                            logoOpacity = 1.0
                        }
                    }
                
                // App name
                Text("SocialConnect")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(textOpacity)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1.0).delay(0.5)) {
                            textOpacity = 1.0
                        }
                    }
                
                // Tagline
                Text("Connect with the world")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .opacity(textOpacity)
            }
        }
    }
}

// MARK: - Auth View
struct AuthView: View {
    @State private var isSignUp = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                AuthHeaderView()
                
                // Auth forms
                if isSignUp {
                    SignUpView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                } else {
                    SignInView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                }
                
                // Toggle button
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSignUp.toggle()
                    }
                } label: {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Auth Header View
struct AuthHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Logo
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            // Title
            Text("Welcome to SocialConnect")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            // Subtitle
            Text("Connect, share, and discover amazing content")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }
}

// MARK: - Sign In View
struct SignInView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Form fields
            VStack(spacing: 16) {
                CustomTextField(
                    text: $email,
                    placeholder: "Email",
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
            }
            .padding(.horizontal, 32)
            
            // Sign in button
            PrimaryButton(
                title: "Sign In",
                isLoading: isLoading
            ) {
                signIn()
            }
            .padding(.horizontal, 32)
            
            Text("Demo account: \(LocalAuthService.demoAccount.email) / \(LocalAuthService.demoAccount.password)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .alert("Sign In Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await authManager.signIn(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}

// MARK: - Sign Up View
struct SignUpView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Form fields
            VStack(spacing: 16) {
                CustomTextField(
                    text: $username,
                    placeholder: "Username",
                    icon: "person",
                    validation: .username
                )
                
                CustomTextField(
                    text: $email,
                    placeholder: "Email",
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
            .padding(.horizontal, 32)
            
            // Sign up button
            PrimaryButton(
                title: "Create Account",
                isLoading: isLoading
            ) {
                signUp()
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .alert("Sign Up Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func signUp() {
        guard !username.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        isLoading = true
        
        Task {
            do {
                try await authManager.signUp(username: username, email: email, password: password)
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            }
        }
    }
}
