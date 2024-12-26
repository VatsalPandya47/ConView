import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: UUID
    var username: String
    var email: String
    var profileImageURL: String?
    var bio: String?
    var skills: [String]
    var socialLinks: [String: String]
    var accountType: AccountType
    
    enum AccountType: String, Codable, CaseIterable {
        case creator
        case collaborator
        case agency
    }
    
    init(
        id: UUID = UUID(),
        username: String,
        email: String,
        profileImageURL: String? = nil,
        bio: String? = nil,
        skills: [String] = [],
        socialLinks: [String: String] = [:],
        accountType: AccountType = .creator
    ) {
        self.id = id
        self.username = username
        self.email = email
        self.profileImageURL = profileImageURL
        self.bio = bio
        self.skills = skills
        self.socialLinks = socialLinks
        self.accountType = accountType
    }
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    // Validation methods
    func isValid() -> Bool {
        return !username.isEmpty && 
               email.contains("@") && 
               (bio?.count ?? 0) <= 500
    }
} 