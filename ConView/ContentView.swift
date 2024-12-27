//
//  ContentView.swift
//  ConView
//
//  Created by Vatsal Pandya on 12/26/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                AuthenticationView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DependencyContainer.shared.authenticationManager)
}
