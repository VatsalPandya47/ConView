//
//  ConViewApp.swift
//  CreatorConnect
//
//  Created by Vatsal Pandya on 12/26/24.
//

import SwiftUI
import Firebase

@main
struct CreatorConnectApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
        }
    }
}
