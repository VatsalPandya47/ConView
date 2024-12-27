import Foundation

enum Environment {
    case development
    case staging
    case production
    
    var baseURL: URL {
        switch self {
        case .development:
            return URL(string: "https://dev-api.yourapp.com")!
        case .staging:
            return URL(string: "https://staging-api.yourapp.com")!
        case .production:
            return URL(string: "https://api.yourapp.com")!
        }
    }
}

final class AppConfiguration {
    static let shared = AppConfiguration()
    
    let environment: Environment
    let apiKey: String
    
    private init() {
        #if DEBUG
        self.environment = .development
        #else
        self.environment = .production
        #endif
        
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("API Key not found in Info.plist")
        }
        self.apiKey = apiKey
    }
} 