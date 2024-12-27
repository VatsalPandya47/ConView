import SwiftUI

struct ProfileCardView: View {
    let user: User
    @State private var imageOffset: CGSize = .zero
    @State private var initialOffset: CGSize = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            // Profile Image
            ZStack {
                AsyncImage(url: URL(string: user.profileImageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 400)
                .offset(imageOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation
                            imageOffset = CGSize(
                                width: initialOffset.width + translation.width,
                                height: initialOffset.height + translation.height
                            )
                        }
                        .onEnded { _ in
                            withAnimation(.spring()) {
                                imageOffset = .zero
                                initialOffset = .zero
                            }
                        }
                )
                
                // Gradient overlay
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black.opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            
            // Profile Info
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(user.username)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if user.accountType == .creator {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(HingeStyle.Colors.primary)
                    }
                }
                
                if let bio = user.bio {
                    Text(bio)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // Skills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(user.skills, id: \.self) { skill in
                            Text(skill)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(HingeStyle.Colors.secondary.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding()
        }
        .modifier(HingeCardModifier())
    }
} 