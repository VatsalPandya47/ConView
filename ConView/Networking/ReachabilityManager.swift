import Network
import Combine

enum ReachabilityStatus {
    case connected(ConnectionType)
    case disconnected
    
    enum ConnectionType {
        case wifi
        case cellular
        case wired
        case other
    }
}

final class ReachabilityManager: ObservableObject {
    static let shared = ReachabilityManager()
    
    @Published private(set) var status: ReachabilityStatus = .disconnected
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.conview.reachability")
    
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.status = self.determineStatus(from: path)
            }
        }
        monitor.start(queue: queue)
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
    
    private func determineStatus(from path: NWPath) -> ReachabilityStatus {
        if !path.status.isReachable {
            return .disconnected
        }
        
        if path.usesInterfaceType(.wifi) {
            return .connected(.wifi)
        } else if path.usesInterfaceType(.cellular) {
            return .connected(.cellular)
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .connected(.wired)
        } else {
            return .connected(.other)
        }
    }
} 