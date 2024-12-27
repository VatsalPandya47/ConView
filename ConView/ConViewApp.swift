//
//  ConViewApp.swift
//  CreatorConnect
//
//  Created by Vatsal Pandya on 12/26/24.
//

import SwiftUI
import Firebase

@main
struct ConViewApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DependencyContainer.shared.authenticationManager)
                .environmentObject(appState)
                .preferredColorScheme(appState.colorScheme)
                .task {
                    await appState.configure()
                }
        }
    }
}

// App-wide state management
class AppState: ObservableObject {
    @Published var colorScheme: ColorScheme?
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    
    func configure() async {
        if isFirstLaunch {
            // Handle first launch setup
            isFirstLaunch = false
        }
    }
}
