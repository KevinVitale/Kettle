import Foundation

public struct ClientConfiguration: Codable, ExpressibleByStringLiteral {
    private let components: URLComponents
    
    public init(scheme: String = "http", host: String, port: Int = 8545) {
        self.components = URLComponents(string: "\(scheme)://\(host):\(port)")!
    }
    
    public init(stringLiteral value: String) {
        components = URLComponents(string: value)!
    }
    
    public var url: URL {
        components.url!
    }
}
