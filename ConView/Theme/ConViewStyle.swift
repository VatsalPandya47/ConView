import SwiftUI

enum ConViewStyle {
    enum Colors {
        static let primary = Color("ConViewPink")
        static let secondary = Color("ConViewGray")
        static let background = Color("ConViewBackground")
        static let cardBackground = Color("CardBackground")
        static let textPrimary = Color("TextPrimary")
        static let textSecondary = Color("TextSecondary")
        
        // Gradients
        static let primaryGradient = LinearGradient(
            colors: [Color("GradientStart"), Color("GradientEnd")],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    enum Animations {
        static let springAnimation = Animation.spring(
            response: 0.4,
            dampingFraction: 0.7,
            blendDuration: 0.3
        )
        
        static let cardAnimation = Animation.interpolatingSpring(
            mass: 1.0,
            stiffness: 100,
            damping: 16,
            initialVelocity: 0
        )
    }
    
    enum Layout {
        static let cardCornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 25
        static let standardPadding: CGFloat = 16
        static let cardSpacing: CGFloat = 12
    }
} 