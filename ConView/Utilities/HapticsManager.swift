import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    
    private init() {
        feedback.prepare()
        impactFeedback.prepare()
    }
    
    func success() {
        feedback.notificationOccurred(.success)
    }
    
    func error() {
        feedback.notificationOccurred(.error)
    }
    
    func warning() {
        feedback.notificationOccurred(.warning)
    }
    
    func impact() {
        impactFeedback.impactOccurred()
    }
} 