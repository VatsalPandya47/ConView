import SwiftUI

struct ConViewCardModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .background(ConViewStyle.Colors.cardBackground)
            .cornerRadius(ConViewStyle.Layout.cardCornerRadius)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: isPressed ? 4 : 8,
                x: 0,
                y: isPressed ? 2 : 4
            )
            .scaleEffect(isPressed ? 0.98 : 1)
            .animation(ConViewStyle.Animations.cardAnimation, value: isPressed)
    }
}

struct ConViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(ConViewStyle.Colors.primaryGradient)
            .foregroundColor(.white)
            .cornerRadius(ConViewStyle.Layout.buttonCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
} 