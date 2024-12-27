import Foundation

protocol AppErrorProtocol: LocalizedError {
    var title: String { get }
    var code: Int { get }
}

struct AppError: AppErrorProtocol, Identifiable {
    let id = UUID()
    let title: String
    let code: Int
    let errorDescription: String?
    let failureReason: String?
    let recoverySuggestion: String?
    
    init(
        title: String,
        code: Int,
        description: String? = nil,
        failureReason: String? = nil,
        recoverySuggestion: String? = nil
    ) {
        self.title = title
        self.code = code
        self.errorDescription = description
        self.failureReason = failureReason
        self.recoverySuggestion = recoverySuggestion
    }
}

extension AppError {
    static func auth(_ error: AuthError) -> AppError {
        AppError(
            title: error.title,
            code: error.code,
            description: error.errorDescription,
            failureReason: error.failureReason,
            recoverySuggestion: error.recoverySuggestion
        )
    }
} 