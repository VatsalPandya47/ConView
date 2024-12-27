import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthenticationManager: ObservableObject {
    @Published private(set) var currentUser: User?
    @Published private(set) var isAuthenticated = false
    @Published private(set) var error: AppError?
    @Published private(set) var isLoading = false
    
    private let db = Firestore.firestore()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let listener = authStateListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
    
    func refreshSession() {
        Task { @MainActor in
            guard let user = Auth.auth().currentUser else { return }
            do {
                try await user.reload()
                await fetchUserDetails(user)
            } catch {
                self.error = .authentication(.networkError)
            }
        }
    }
    
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            guard let self = self else { return }
            Task { @MainActor in
                if let user = user {
                    await self.fetchUserDetails(user)
                } else {
                    self.currentUser = nil
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    @MainActor
    private func fetchUserDetails(_ user: FirebaseAuth.User) async {
        do {
            let document = try await db.collection("users").document(user.uid).getDocument()
            if document.exists, let data = document.data() {
                self.currentUser = User(
                    id: user.uid,
                    username: data["username"] as? String ?? user.displayName ?? "",
                    email: user.email ?? "",
                    profileImageURL: data["profileImageURL"] as? String,
                    bio: data["bio"] as? String,
                    skills: data["skills"] as? [String] ?? [],
                    accountType: User.AccountType(rawValue: data["accountType"] as? String ?? "viewer") ?? .viewer
                )
                self.isAuthenticated = true
            } else {
                await createUserDocument(user)
            }
        } catch {
            self.error = .network(.serverError)
        }
    }
    
    private func createUserDocument(_ user: FirebaseAuth.User) async {
        let newUser = User(
            id: user.uid,
            username: user.displayName ?? "",
            email: user.email ?? "",
            profileImageURL: user.photoURL?.absoluteString,
            accountType: .viewer
        )
        
        let userData: [String: Any] = [
            "id": newUser.id,
            "username": newUser.username,
            "email": newUser.email,
            "profileImageURL": newUser.profileImageURL ?? "",
            "bio": newUser.bio ?? "",
            "skills": newUser.skills,
            "accountType": newUser.accountType.rawValue
        ]
        
        do {
            try await db.collection("users").document(newUser.id).setData(userData)
            self.currentUser = newUser
            self.isAuthenticated = true
        } catch {
            self.error = .network(.serverError)
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