import SwiftUI

extension AnyTransition {
    static var conViewCard: AnyTransition {
        .asymmetric(
            insertion: .opacity
                .combined(with: .scale(scale: 0.8))
                .combined(with: .offset(y: 50)),
            removal: .opacity
                .combined(with: .scale(scale: 0.6))
                .combined(with: .offset(y: -50))
        )
    }
    
    static var slideAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
} 