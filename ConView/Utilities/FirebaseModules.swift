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
        // Prevent multiple configurations
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Optional: Enable debug logging
        #if DEBUG
        FirebaseConfiguration.shared.setLoggerLevel(.debug)
        #endif
    }
    
    // Helper method to ensure Firebase is configured
    func ensureConfiguration() {
        // This method can be called explicitly if needed
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
} 