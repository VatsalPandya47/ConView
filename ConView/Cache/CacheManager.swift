import Foundation

protocol CacheManagerProtocol {
    func cache<T: Codable>(_ item: T, forKey key: String) throws
    func retrieve<T: Codable>(forKey key: String) throws -> T
    func remove(forKey key: String)
    func clearAll()
}

final class CacheManager: CacheManagerProtocol {
    static let shared = CacheManager()
    
    private let cache = NSCache<NSString, NSData>()
    private let queue = DispatchQueue(label: "com.conview.cache")
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = urls[0].appendingPathComponent("com.conview.cache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    func cache<T: Codable>(_ item: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(item)
        queue.async {
            self.cache.setObject(data as NSData, forKey: key as NSString)
            try? data.write(to: self.cacheDirectory.appendingPathComponent(key))
        }
    }
    
    func retrieve<T: Codable>(forKey key: String) throws -> T {
        if let cachedData = cache.object(forKey: key as NSString) as Data? {
            return try JSONDecoder().decode(T.self, from: cachedData)
        }
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        let data = try Data(contentsOf: fileURL)
        let item = try JSONDecoder().decode(T.self, from: data)
        
        queue.async {
            self.cache.setObject(data as NSData, forKey: key as NSString)
        }
        
        return item
    }
    
    func remove(forKey key: String) {
        queue.async {
            self.cache.removeObject(forKey: key as NSString)
            try? self.fileManager.removeItem(at: self.cacheDirectory.appendingPathComponent(key))
        }
    }
    
    func clearAll() {
        queue.async {
            self.cache.removeAllObjects()
            try? self.fileManager.removeItem(at: self.cacheDirectory)
            try? self.fileManager.createDirectory(at: self.cacheDirectory, withIntermediateDirectories: true)
        }
    }
} 