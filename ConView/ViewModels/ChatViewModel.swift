import Foundation
import Combine
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText = ""
    @Published var isTyping = false
    
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    private var typingTimer: Timer?
    
    init() {
        setupTypingPublisher()
    }
    
    private func setupTypingPublisher() {
        $messageText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.startTyping()
                } else {
                    self?.stopTyping()
                }
            }
            .store(in: &cancellables)
    }
    
    func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let message = Message(
            text: messageText,
            timestamp: Date(),
            isFromCurrentUser: true
        )
        
        messages.append(message)
        messageText = ""
        
        // Simulate typing response
        simulateResponse()
    }
    
    private func simulateResponse() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isTyping = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isTyping = false
                
                let response = Message(
                    text: "Thanks for reaching out! I'd love to collaborate.",
                    timestamp: Date(),
                    isFromCurrentUser: false
                )
                
                withAnimation {
                    self.messages.append(response)
                }
                
                HapticsManager.shared.success()
            }
        }
    }
    
    private func startTyping() {
        isTyping = true
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.stopTyping()
        }
    }
    
    private func stopTyping() {
        isTyping = false
        typingTimer?.invalidate()
        typingTimer = nil
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let timestamp: Date
    let isFromCurrentUser: Bool
} 