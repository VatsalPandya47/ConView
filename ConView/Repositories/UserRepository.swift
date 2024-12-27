import Foundation
import FirebaseFirestore

actor UserRepository {
    private let db = Firestore.firestore()
    
    func fetchUser(id: String) async throws -> User {
        let snapshot = try await db.collection("users").document(id).getDocument()
        guard let data = snapshot.data() else {
            throw AppError(
                title: "User Not Found",
                code: 404,
                description: "Unable to find user with ID: \(id)"
            )
        }
        return try Firestore.Decoder().decode(User.self, from: data)
    }
    
    func saveUser(_ user: User) async throws {
        let data = try Firestore.Encoder().encode(user)
        try await db.collection("users").document(user.id).setData(data)
    }
} 