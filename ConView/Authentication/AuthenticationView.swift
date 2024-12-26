import SwiftUI

struct AuthenticationView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var isLoginView = true
    
    var body: some Scene {
        NavigationView {
            if authManager.isAuthenticated {
                MainTabView()
                    .environmentObject(authManager)
            } else {
                VStack {
                    if isLoginView {
                        LoginView(
                            authManager: authManager, 
                            switchToSignUp: { isLoginView = false }
                        )
                    } else {
                        SignUpView(
                            authManager: authManager, 
                            switchToLogin: { isLoginView = true }
                        )
                    }
                }
                .alert(item: Binding(
                    get: { authManager.error },
                    set: { _ in authManager.error = nil }
                )) { error in
                    Alert(
                        title: Text("Error"),
                        message: Text(errorMessage(for: error)),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    private func errorMessage(for error: AppError?) -> String {
        guard let error = error else { return "Unknown error" }
        
        switch error {
        case .authentication(let authError):
            return authError.localizedDescription
        case .network(let networkError):
            return "Network error: \(networkError.rawValue)"
        case .validation(let validationError):
            return "Validation error: \(validationError.rawValue)"
        }
    }
}

struct LoginView: View {
    @ObservedObject var authManager: AuthenticationManager
    var switchToSignUp: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("CreatorConnect")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disabled(isLoading)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isLoading)
            
            if isLoading {
                ProgressView()
            } else {
                Button("Login") {
                    isLoading = true
                    authManager.login(email: email, password: password)
                    
                    // Reset loading state after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(email.isEmpty || password.isEmpty)
            }
            
            Button("Create an Account") {
                switchToSignUp()
            }
            .foregroundColor(.blue)
        }
        .padding()
        .animation(.default, value: isLoading)
        .navigationTitle("Login")
    }
}

struct SignUpView: View {
    @ObservedObject var authManager: AuthenticationManager
    var switchToLogin: () -> Void
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isLoading)
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .disabled(isLoading)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isLoading)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(isLoading)
            
            if isLoading {
                ProgressView()
            } else {
                Button("Create Account") {
                    if password == confirmPassword {
                        isLoading = true
                        authManager.signUp(username: username, email: email, password: password)
                        
                        // Reset loading state after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoading = false
                        }
                    } else {
                        authManager.error = .authentication(.signUpFailed)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            
            Button("Already have an account? Login") {
                switchToLogin()
            }
            .foregroundColor(.blue)
        }
        .padding()
        .navigationTitle("Sign Up")
        .animation(.default, value: isLoading)
    } 