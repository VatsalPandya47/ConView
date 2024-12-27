import Foundation
import FirebaseAnalytics

enum AnalyticsEvent {
    case userLogin
    case userSignup
    case viewContent(name: String)
    
    var name: String {
        switch self {
        case .userLogin: return "user_login"
        case .userSignup: return "user_signup"
        case .viewContent: return "view_content"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .viewContent(let name):
            return ["content_name": name]
        default:
            return nil
        }
    }
}

struct Analytics {
    static func logEvent(_ event: AnalyticsEvent) {
        FirebaseAnalytics.Analytics.logEvent(event.name, parameters: event.parameters)
    }
} 