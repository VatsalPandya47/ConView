import Foundation
import SwiftUI
import Firebase

class DependencyContainer {
    static let shared = DependencyContainer()
    
    lazy var authenticationManager = AuthenticationManager()
    
    private init() {
        FirebaseApp.configure()
    }
} 