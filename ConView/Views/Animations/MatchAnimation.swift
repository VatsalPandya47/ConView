import SwiftUI

struct MatchAnimation: View {
    let matchedUser: User
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Match text animation
                Text("It's a Match!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(isShowing ? 1 : 0)
                    .scaleEffect(isShowing ? 1 : 0.5)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isShowing)
                
                // Profile images
                HStack(spacing: 20) {
                    AsyncImage(url: URL(string: matchedUser.profileImageURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .offset(x: isShowing ? 0 : -200)
                    
                    AsyncImage(url: URL(string: matchedUser.profileImageURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .offset(x: isShowing ? 0 : 200)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: isShowing)
                
                // Action buttons
                VStack(spacing: 16) {
                    Button("Send Message") {
                        // Handle message action
                    }
                    .buttonStyle(ConViewButtonStyle())
                    
                    Button("Keep Swiping") {
                        withAnimation {
                            isShowing = false
                        }
                    }
                    .foregroundColor(.white)
                }
                .opacity(isShowing ? 1 : 0)
                .animation(.easeInOut.delay(0.3), value: isShowing)
            }
        }
        .onAppear {
            HapticsManager.shared.success()
        }
    }
} 