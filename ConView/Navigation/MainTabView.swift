import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        TabView {
            DiscoveryView()
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
            
            MessagingView()
                .tabItem {
                    Label("Messages", systemImage: "message")
                }
            
            CollaborationView()
                .tabItem {
                    Label("Collaborate", systemImage: "person.2")
                }
        }
    }
}

// Add missing view structs
struct MessagingView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Conversation 1")
                Text("Conversation 2")
                Text("Conversation 3")
            }
            .navigationTitle("Messages")
        }
    }
}

struct CollaborationView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Open Opportunities")) {
                    Text("Video Production Project")
                    Text("Design Collaboration")
                }
                
                Section(header: Text("Your Proposals")) {
                    Text("Pending Proposal 1")
                    Text("Accepted Proposal 2")
                }
            }
            .navigationTitle("Collaborate")
        }
    }
} 