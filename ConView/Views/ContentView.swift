import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var appState: AppState
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        Group {
            if authManager.isLoading {
                LoadingView()
            } else if authManager.isAuthenticated {
                MainTabView()
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
            } else {
                AuthenticationView()
                    .transition(.opacity.combined(with: .move(edge: .leading)))
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: authManager.isAuthenticated)
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                authManager.refreshSession()
            case .background:
                // Handle background state
                break
            case .inactive:
                // Handle inactive state
                break
            @unknown default:
                break
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .font(.headline)
        }
    }
} 