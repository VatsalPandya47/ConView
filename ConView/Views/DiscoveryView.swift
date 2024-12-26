import SwiftUI

struct DiscoveryView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                List {
                    Section(header: Text("Trending Creators")) {
                        Text("Creator 1")
                        Text("Creator 2")
                        Text("Creator 3")
                    }
                    
                    Section(header: Text("Recommended")) {
                        Text("Creator 4")
                        Text("Creator 5")
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("Discovery")
            }
        }
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("Creator Name")
                    .font(.title)
                
                Text("Content Creator | Photographer")
                    .foregroundColor(.secondary)
                
                List {
                    Section(header: Text("Portfolio")) {
                        Text("Project 1")
                        Text("Project 2")
                    }
                    
                    Section(header: Text("Skills")) {
                        Text("Photography")
                        Text("Video Editing")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

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

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search creators", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
    }
} 