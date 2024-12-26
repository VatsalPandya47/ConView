import Foundation
import Combine
import SwiftUI

class AuthenticationManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var error: AppError?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupErrorHandling()
    }
    
    private func setupErrorHandling() {
        // Optional: Add error logging or analytics
    }
    
    func login(email: String, password: String) {
        guard validateLoginInput(email: email, password: password) else {
            return
        }
        
        // Simulated async login with error handling
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            // Simulate potential login failure
            if email == "fail@example.com" {
                self.error = .authentication(.invalidCredentials)
                return
            }
            
            // Successful login simulation
            let mockUser = User(
                username: "creator_\(UUID().uuidString.prefix(5))",
                email: email,
                profileImageURL: nil,
                bio: "New creator",
                skills: [],
                socialLinks: [:]
            )
            
            self.currentUser = mockUser
            self.isAuthenticated = true
        }
    }
    
    func signUp(username: String, email: String, password: String) {
        guard validateSignUpInput(username: username, email: email, password: password) else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            // Simulate potential signup failure
            if email == "existing@example.com" {
                self.error = .authentication(.emailAlreadyInUse)
                return
            }
            
            let newUser = User(
                username: username,
                email: email,
                bio: "New creator joining the community",
                skills: []
            )
            
            self.currentUser = newUser
            self.isAuthenticated = true
        }
    }
    
    private func validateLoginInput(email: String, password: String) -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            error = .validation(.missingRequiredFields)
            return false
        }
        
        guard email.contains("@") else {
            error = .validation(.invalidEmail)
            return false
        }
        
        guard password.count >= 6 else {
            error = .validation(.passwordTooShort)
            return false
        }
        
        return true
    }
    
    private func validateSignUpInput(username: String, email: String, password: String) -> Bool {
        guard !username.isEmpty else {
            error = .validation(.missingRequiredFields)
            return false
        }
        
        guard !email.isEmpty, email.contains("@") else {
            error = .validation(.invalidEmail)
            return false
        }
        
        guard password.count >= 6 else {
            error = .validation(.passwordTooShort)
            return false
        }
        
        return true
    }
    
    func logout() {
        currentUser = nil
        isAuthenticated = false
        error = nil
    }
} 