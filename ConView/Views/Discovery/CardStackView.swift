import SwiftUI

struct CardStackView: View {
    @StateObject private var viewModel = CardStackViewModel()
    private let cardOffset: CGFloat = 12
    
    var body: some View {
        ZStack {
            ForEach(viewModel.visibleCards.reversed()) { user in
                CardView(user: user)
                    .offset(y: CGFloat(viewModel.indexOf(user)) * -cardOffset)
                    .zIndex(Double(viewModel.indexOf(user)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                viewModel.updateCardOffset(for: user, with: gesture)
                            }
                            .onEnded { gesture in
                                viewModel.handleSwipe(for: user, with: gesture)
                            }
                    )
            }
        }
        .padding()
    }
}

class CardStackViewModel: ObservableObject {
    @Published var visibleCards: [User] = []
    @Published private var cardOffsets: [UUID: CGSize] = [:]
    
    private let swipeThreshold: CGFloat = 150
    
    func indexOf(_ user: User) -> Int {
        visibleCards.firstIndex(where: { $0.id == user.id }) ?? 0
    }
    
    func updateCardOffset(for user: User, with gesture: DragGesture.Value) {
        cardOffsets[user.id] = gesture.translation
    }
    
    func handleSwipe(for user: User, with gesture: DragGesture.Value) {
        let offset = gesture.translation.width
        if abs(offset) > swipeThreshold {
            if offset > 0 {
                handleLike(user)
            } else {
                handlePass(user)
            }
        } else {
            resetPosition(for: user)
        }
    }
    
    private func handleLike(_ user: User) {
        withAnimation {
            removeCard(user)
        }
        HapticsManager.shared.success()
    }
    
    private func handlePass(_ user: User) {
        withAnimation {
            removeCard(user)
        }
        HapticsManager.shared.impact()
    }
    
    private func removeCard(_ user: User) {
        visibleCards.removeAll { $0.id == user.id }
    }
    
    private func resetPosition(for user: User) {
        withAnimation(.spring()) {
            cardOffsets[user.id] = .zero
        }
    }
} 