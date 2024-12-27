import Foundation

protocol AuthenticationServiceProtocol {
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }
    func login(email: String, password: String) async throws
    func signUp(username: String, email: String, password: String) async throws
    func signOut() throws
}

protocol AnalyticsServiceProtocol {
    func logEvent(_ event: AnalyticsEvent)
    func setUserProperty(_ value: String?, forName name: String)
}

class DependencyContainer {
    static let shared = DependencyContainer()
    
    // Services
    private(set) lazy var authService: AuthenticationServiceProtocol = AuthenticationManager()
    private(set) lazy var analyticsService: AnalyticsServiceProtocol = AnalyticsService()
    
    // Repositories
    private(set) lazy var userRepository = UserRepository()
    
    // View Models
    func makeAuthViewModel() -> AuthViewModel {
        AuthViewModel(
            authService: authService,
            analyticsService: analyticsService,
            userRepository: userRepository
        )
    }
    
    private init() {}
} 