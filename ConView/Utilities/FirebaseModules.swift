import Foundation
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

// This file serves as a centralized import and configuration point for Firebase modules
class FirebaseModuleManager {
    static let shared = FirebaseModuleManager()
    private var isConfigured = false
    
    private init() {
        configureFirebase()
    }
    
    private func configureFirebase() {
        guard !isConfigured else { return }
        
        do {
            if FirebaseApp.app() == nil {
                FirebaseApp.configure()
                
                #if DEBUG
                FirebaseConfiguration.shared.setLoggerLevel(.debug)
                #endif
                
                isConfigured = true
            }
        } catch {
            print("Error configuring Firebase: \(error.localizedDescription)")
        }
    }
    
    // Helper method to ensure Firebase is configured
    func ensureConfiguration() {
        if !isConfigured {
            configureFirebase()
        }
    }
} 