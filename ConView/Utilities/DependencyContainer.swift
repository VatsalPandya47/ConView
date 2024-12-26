import Foundation
import SwiftUI

class DependencyContainer {
    static let shared = DependencyContainer()
    
    lazy var authenticationManager = AuthenticationManager()
    
    private init() {}
} 