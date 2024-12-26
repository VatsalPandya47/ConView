//
//  ConViewApp.swift
//  CreatorConnect
//
//  Created by Vatsal Pandya on 12/26/24.
//

import SwiftUI
import Combine

@main
struct CreatorConnectApp: App {
    // App-wide authentication manager
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .environmentObject(authManager)
        }
    }
}
