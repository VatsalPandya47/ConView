import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthenticationManager: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var error: AppError?
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    
    init() {
        setupFirebaseAuthListener()
    }
    
    private func setupFirebaseAuthListener() {
        Auth.auth().addStateDidChangeListener { [weak self] (_, firebaseUser) in
            guard let self = self else { return }
            
            if let firebaseUser = firebaseUser {
                self.fetchUserDetails(firebaseUser: firebaseUser)
            } else {
                self.currentUser = nil
                self.isAuthenticated = false
            }
        }
    }
    
    private func fetchUserDetails(firebaseUser: FirebaseAuth.User) {
        let userRef = db.collection("users").document(firebaseUser.uid)
        
        userRef.getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let document = document, document.exists,
               let data = document.data() {
                let user = User(
                    id: UUID(uuidString: firebaseUser.uid) ?? UUID(),
                    username: data["username"] as? String ?? firebaseUser.displayName ?? "",
                    email: firebaseUser.email ?? "",
                    profileImageURL: data["profileImageURL"] as? String,
                    bio: data["bio"] as? String,
                    skills: data["skills"] as? [String] ?? [],
                    accountType: User.AccountType(rawValue: data["accountType"] as? String ?? "creator") ?? .creator
                )
                
                self.currentUser = user
                self.isAuthenticated = true
            } else {
                // Create user document if it doesn't exist
                self.createUserDocument(firebaseUser: firebaseUser)
            }
        }
    }
    
    private func createUserDocument(firebaseUser: FirebaseAuth.User) {
        let userData: [String: Any] = [
            "uid": firebaseUser.uid,
            "username": firebaseUser.displayName ?? "",
            "email": firebaseUser.email ?? "",
            "profileImageURL": firebaseUser.photoURL?.absoluteString ?? "",
            "accountType": "creator"
        ]
        
        db.collection("users").document(firebaseUser.uid).setData(userData) { [weak self] error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
            } else {
                self?.isAuthenticated = true
            }
        }
    }
    
    func login(email: String, password: String) {
        isLoading = true
        error = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                self.error = AppError.fromFirebaseError(error)
                return
            }
        }
    }
    
    func signUp(username: String, email: String, password: String) {
        isLoading = true
        error = nil
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if let error = error {
                self.error = AppError.fromFirebaseError(error)
                return
            }
            
            // Update user profile with username
            let changeRequest = result?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges { [weak self] error in
                if let error = error {
                    print("Error updating profile: \(error.localizedDescription)")
                }
                
                // Create user document in Firestore
                guard let user = result?.user else { return }
                
                let userData: [String: Any] = [
                    "uid": user.uid,
                    "username": username,
                    "email": email,
                    "accountType": "creator"
                ]
                
                self?.db.collection("users").document(user.uid).setData(userData)
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}