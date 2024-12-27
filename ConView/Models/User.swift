import Foundation

struct User: Codable, Identifiable {
    let id: String
    let username: String
    let email: String
    let profileImageURL: String?
    let bio: String?
    var skills: [String]
    let accountType: AccountType
    
    enum AccountType: String, Codable {
        case creator
        case viewer
    }
    
    init(id: String = UUID().uuidString,
         username: String,
         email: String,
         profileImageURL: String? = nil,
         bio: String? = nil,
         skills: [String] = [],
         accountType: AccountType = .viewer) {
        self.id = id
        self.username = username
        self.email = email
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.skills = skills
        self.accountType = accountType
    }
} 