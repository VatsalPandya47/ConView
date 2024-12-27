import Foundation

protocol AnalyticsTracking {
    func track(_ event: AnalyticsEvent)
    func setUserProperty(_ property: UserProperty)
}

struct AnalyticsTracker: AnalyticsTracking {
    private let providers: [AnalyticsProvider]
    
    init(providers: [AnalyticsProvider] = [
        FirebaseAnalyticsProvider(),
        AppsFlyerProvider(),
        MixpanelProvider()
    ]) {
        self.providers = providers
    }
    
    func track(_ event: AnalyticsEvent) {
        providers.forEach { $0.track(event) }
    }
    
    func setUserProperty(_ property: UserProperty) {
        providers.forEach { $0.setUserProperty(property) }
    }
}

protocol AnalyticsProvider {
    func track(_ event: AnalyticsEvent)
    func setUserProperty(_ property: UserProperty)
}

struct UserProperty {
    let name: String
    let value: Any
}

enum AnalyticsEvent {
    case screenView(screen: String)
    case buttonTap(name: String)
    case userAction(name: String, parameters: [String: Any]?)
    
    var name: String {
        switch self {
        case .screenView(let screen):
            return "screen_view_\(screen)"
        case .buttonTap(let name):
            return "button_tap_\(name)"
        case .userAction(let name, _):
            return "user_action_\(name)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .screenView(let screen):
            return ["screen_name": screen]
        case .buttonTap(let name):
            return ["button_name": name]
        case .userAction(_, let parameters):
            return parameters
        }
    }
} 