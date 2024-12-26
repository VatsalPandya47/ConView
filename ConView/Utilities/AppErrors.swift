import Foundation

enum AppError: Error, Identifiable {
    case authentication(AuthenticationError)
    case network(NetworkError)
    case validation(ValidationError)
    
    var id: String {
        switch self {
        case .authentication(let error):
            return "auth_\(error.id)"
        case .network(let error):
            return "network_\(error.rawValue)"
        case .validation(let error):
            return "validation_\(error.rawValue)"
        }
    }
}

enum NetworkError: String, Error {
    case noConnection
    case serverError
    case timeout
    case badResponse
}

enum ValidationError: String, Error {
    case invalidEmail
    case passwordTooShort
    case missingRequiredFields
    case invalidUsername
} 