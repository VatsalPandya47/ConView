import Foundation

struct User: Codable {
    let username: String
    let email: String
    let profileImageURL: String?
    let bio: String?
    var skills: [String] = []
    let accountType: AccountType
    
    enum AccountType: String, Codable {
        case creator
        case viewer
    }
} 