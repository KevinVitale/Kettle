import Foundation

public enum NetworkID: RawRepresentable, Identifiable, Decodable, Equatable {
    case mainnet
    case modren
    case ropsten
    case rinkbey
    case kovan
    case unknown(String)
    
    public init(rawValue value: String) {
        switch value {
        case "1"  :self = .mainnet
        case "2"  :self = .modren
        case "3"  :self = .ropsten
        case "4"  :self = .rinkbey
        case "42" :self = .kovan
        default   :self = .unknown(value)
        }
    }
    
    public init(rawValue value: String?) {
        self.init(rawValue: value ?? "")
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self = .init(rawValue: value)
    }

    public var decprecated: Bool {
        switch self {
        case .modren: return true
        default:      return false
        }
    }
    
    public var id: String {
        switch self {
        case .mainnet            :return "1"
        case .modren             :return "2"
        case .ropsten            :return "3"
        case .rinkbey            :return "4"
        case .kovan              :return "42"
        case .unknown(let value) :return value
        }
    }
    
    public var rawValue: String { id }
}
