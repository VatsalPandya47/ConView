import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            if let user = authManager.currentUser {
                ScrollView {
                    VStack(alignment: .center, spacing: 15) {
                        AsyncImage(url: URL(string: user.profileImageURL ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        
                        Text(user.username)
                            .font(.title)
                        
                        Text(user.bio ?? "")
                            .foregroundColor(.secondary)
                        
                        HStack {
                            ForEach(user.skills, id: \.self) { skill in
                                Text(skill)
                                    .padding(5)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        Button("Edit Profile") {
                            // TODO: Implement profile editing
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
                .navigationTitle("Profile")
                .navigationBarItems(trailing: 
                    Button("Logout") {
                        authManager.logout()
                    }
                )
            } else {
                Text("Please log in")
            }
        }
    }
} 