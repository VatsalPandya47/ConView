import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let auth = Logger(subsystem: subsystem, category: "authentication")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let viewCycle = Logger(subsystem: subsystem, category: "viewCycle")
    static let userDefaults = Logger(subsystem: subsystem, category: "userDefaults")
} 