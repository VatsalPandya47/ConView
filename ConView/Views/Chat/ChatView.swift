import SwiftUI

struct ChatView: View {
    let matchedUser: User
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            HingeNavigationBar(
                title: matchedUser.username,
                leading: {
                    Button(action: { /* Handle back */ }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(ConViewStyle.Colors.primary)
                    }
                },
                trailing: {
                    Button(action: { /* Handle menu */ }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(ConViewStyle.Colors.primary)
                    }
                }
            )
            
            // Chat messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id)
                    }
                }
            }
            
            // Input area
            HStack(spacing: 12) {
                TextField("Type a message...", text: $viewModel.messageText)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                
                Button(action: viewModel.sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(ConViewStyle.Colors.primary)
                }
                .disabled(viewModel.messageText.isEmpty)
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 2)
        }
    }
} 