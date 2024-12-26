import Foundation

enum AuthenticationError: Error, Identifiable {
    case invalidCredentials
    case accountNotFound
    case networkError
    case signUpFailed
    case emailAlreadyInUse
    
    var id: String {
        switch self {
        case .invalidCredentials: return "invalidCredentials"
        case .accountNotFound: return "accountNotFound"
        case .networkError: return "networkError"
        case .signUpFailed: return "signUpFailed"
        case .emailAlreadyInUse: return "emailAlreadyInUse"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials: return "Invalid email or password"
        case .accountNotFound: return "Account not found"
        case .networkError: return "Network connection error"
        case .signUpFailed: return "Sign up failed"
        case .emailAlreadyInUse: return "Email is already registered"
        }
    }
} 