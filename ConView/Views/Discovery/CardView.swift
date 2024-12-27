import SwiftUI

struct CardView: View {
    let user: User
    @State private var currentPromptIndex = 0
    @State private var dragOffset: CGSize = .zero
    @State private var rotationAngle: Double = 0
    
    private let prompts: [(question: String, answer: String)] = [
        ("I'm looking to collaborate on...", "Creative video projects and brand campaigns"),
        ("My best skill is...", "Visual storytelling and cinematography"),
        ("Let's work together if...", "You're passionate about creating meaningful content")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Image
                AsyncImage(url: URL(string: user.profileImageURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                
                // Gradient Overlay
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .black.opacity(0.3),
                        .black.opacity(0.7)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Content
                VStack(alignment: .leading, spacing: 20) {
                    Spacer()
                    
                    // Prompt Card
                    PromptCard(
                        question: prompts[currentPromptIndex].question,
                        answer: prompts[currentPromptIndex].answer
                    )
                    .onTapGesture {
                        withAnimation {
                            currentPromptIndex = (currentPromptIndex + 1) % prompts.count
                        }
                    }
                    
                    // User Info
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(user.username)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            if user.accountType == .creator {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(ConViewStyle.Colors.primary)
                            }
                        }
                        
                        HStack(spacing: 15) {
                            ForEach(user.skills.prefix(3), id: \.self) { skill in
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                    Text(skill)
                                }
                                .font(.subheadline)
                                .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding()
                
                // Like/Pass Indicators
                ZStack {
                    // Like Label
                    Text("LIKE")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ConViewStyle.Colors.primary, lineWidth: 4)
                        )
                        .foregroundColor(ConViewStyle.Colors.primary)
                        .rotationEffect(.degrees(-30))
                        .opacity(dragOffset.width > 0 ? dragOffset.width/50 : 0)
                    
                    // Pass Label
                    Text("PASS")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 4)
                        )
                        .foregroundColor(.red)
                        .rotationEffect(.degrees(30))
                        .opacity(dragOffset.width < 0 ? -dragOffset.width/50 : 0)
                }
            }
            .cornerRadius(10)
            .offset(dragOffset)
            .rotationEffect(.degrees(rotationAngle))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                        rotationAngle = Double(value.translation.width / 20)
                        HapticsManager.shared.impact()
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            dragOffset = .zero
                            rotationAngle = 0
                        }
                    }
            )
        }
    }
}

struct PromptCard: View {
    let question: String
    let answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            
            Text(answer)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(12)
    }
} 