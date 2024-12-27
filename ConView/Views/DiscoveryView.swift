import SwiftUI

struct DiscoveryView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                
                List {
                    Section(header: Text("Recommended Creators")) {
                        CreatorCard(name: "Tech Innovator", skills: ["UI/UX", "Product Design"])
                        CreatorCard(name: "Digital Artist", skills: ["Illustration", "Animation"])
                    }
                    
                    Section(header: Text("Trending Collaborations")) {
                        CollaborationCard(title: "Video Production", description: "Seeking videographer for startup promo")
                        CollaborationCard(title: "Design Sprint", description: "UX designers wanted for innovative project")
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Discover")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CreatorCard: View {
    let name: String
    let skills: [String]
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                
                HStack {
                    ForEach(skills, id: \.self) { skill in
                        Text(skill)
                            .font(.caption)
                            .padding(4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

struct CollaborationCard: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search creators", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
} 