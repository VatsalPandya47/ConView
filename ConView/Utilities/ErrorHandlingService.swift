import Foundation
import FirebaseAuth

class ErrorHandlingService {
    static func handleAuthenticationError(_ error: Error) -> String {
        let nsError = error as NSError
        
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password. Please try again."
        case AuthErrorCode.userNotFound.rawValue:
            return "No account found with this email."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Email is already in use."
        case AuthErrorCode.networkError.rawValue:
            return "Network error. Please check your connection."
        default:
            return "An unexpected error occurred. Please try again."
        }
    }
} 