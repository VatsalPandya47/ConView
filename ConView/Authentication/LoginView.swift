import SwiftUI

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