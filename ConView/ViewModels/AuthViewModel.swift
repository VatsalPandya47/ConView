import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published private(set) var state: AuthState = .idle
    @Published private(set) var error: AppError?
    
    private let authService: AuthenticationServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(
        authService: AuthenticationServiceProtocol,
        analyticsService: AnalyticsServiceProtocol,
        userRepository: UserRepository
    ) {
        self.authService = authService
        self.analyticsService = analyticsService
        self.userRepository = userRepository
        
        setupBindings()
    }
    
    private func setupBindings() {
        // Setup Combine publishers
    }
    
    func login(email: String, password: String) async {
        state = .loading
        do {
            try await authService.login(email: email, password: password)
            analyticsService.logEvent(.userLogin)
            state = .authenticated
        } catch {
            Logger.auth.error("Login failed: \(error.localizedDescription)")
            self.error = AppError(
                title: "Login Failed",
                code: -1,
                description: error.localizedDescription
            )
            state = .error(error)
        }
    }
}

enum AuthState: Equatable {
    case idle
    case loading
    case authenticated
    case error(Error)
    
    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.loading, .loading),
             (.authenticated, .authenticated):
            return true
        case (.error(let lhsError), .error(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
} 