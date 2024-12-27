import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

class SocialAuthService {
    private let db = Firestore.firestore()
    
    func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { 
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase client ID not found"])))
            return 
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { 
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Root view controller not found"])))
            return 
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Google Sign-In failed"])))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase authentication failed"])))
                    return
                }
                
                let newUser = User(
                    username: firebaseUser.displayName ?? "",
                    email: firebaseUser.email ?? "",
                    profileImageURL: firebaseUser.photoURL?.absoluteString,
                    accountType: .creator
                )
                
                self?.createUserDocumentIfNeeded(firebaseUser: firebaseUser, user: newUser, completion: completion)
            }
        }
    }
    
    private func createUserDocumentIfNeeded(firebaseUser: FirebaseAuth.User, user: User, completion: @escaping (Result<User, Error>) -> Void) {
        let userRef = Firestore.firestore().collection("users").document(firebaseUser.uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // User already exists, return existing user
                completion(.success(user))
                return
            }
            
            // Create new user document
            let userData: [String: Any] = [
                "uid": firebaseUser.uid,
                "username": user.username,
                "email": user.email,
                "profileImageURL": user.profileImageURL ?? "",
                "accountType": user.accountType.rawValue
            ]
            
            userRef.setData(userData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(user))
                }
            }
        }
    }
} 