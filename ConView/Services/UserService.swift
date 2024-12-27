import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    private let db = Firestore.firestore()
    
    func createUserDocument(user: User) {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let userData: [String: Any] = [
            "uid": currentUser.uid,
            "username": user.username,
            "email": user.email,
            "profileImageURL": user.profileImageURL ?? "",
            "bio": user.bio ?? "",
            "skills": user.skills,
            "accountType": user.accountType.rawValue
        ]
        
        db.collection("users").document(currentUser.uid).setData(userData) { error in
            if let error = error {
                print("Error creating user document: \(error)")
            }
        }
    }
}