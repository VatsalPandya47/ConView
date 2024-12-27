import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

// This file serves as a centralized import and configuration point for Firebase modules
class FirebaseModuleManager {
    static let shared = FirebaseModuleManager()
    
    private init() {
        configureFirebase()
    }
    
    private func configureFirebase() {
        do {
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
                
                #if DEBUG
                FirebaseConfiguration.shared.setLoggerLevel(.debug)
                #endif
            }
        } catch {
            print("Error configuring Firebase: \(error)")
        }
    }
    
    // Helper method to ensure Firebase is configured
    func ensureConfiguration() {
        if FirebaseApp.app() == nil {
            configureFirebase()
        }
    }
} 