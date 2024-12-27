import Foundation
import LocalAuthentication

class BiometricAuthService {
    enum BiometricError: Error {
        case biometryNotAvailable
        case authenticationFailed
        case canceledByUser
        case fallback
    }
    
    func authenticateUser(completion: @escaping (Result<Bool, BiometricError>) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(.failure(.biometryNotAvailable))
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access CreatorConnect") { success, authError in
            DispatchQueue.main.async {
                if success {
                    completion(.success(true))
                } else {
                    guard let laError = authError as? LAError else {
                        completion(.failure(.authenticationFailed))
                        return
                    }
                    
                    switch laError.code {
                    case .userCancel:
                        completion(.failure(.canceledByUser))
                    case .userFallback:
                        completion(.failure(.fallback))
                    default:
                        completion(.failure(.authenticationFailed))
                    }
                }
            }
        }
    }
} 