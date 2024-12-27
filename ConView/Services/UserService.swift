import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserService {
    private let db = Firestore.firestore()
    
    func createUserDocument(user: User, completion: ((Error?) -> Void)? = nil) {
        let userData: [String: Any] = [
            "id": user.id,
            "username": user.username,
            "email": user.email,
            "profileImageURL": user.profileImageURL ?? "",
            "bio": user.bio ?? "",
            "skills": user.skills,
            "accountType": user.accountType.rawValue
        ]
        
        db.collection("users").document(user.id).setData(userData) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
                completion?(error)
            } else {
                completion?(nil)
            }
        }
    }
}