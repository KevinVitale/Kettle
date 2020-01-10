import Foundation
import BigInt
import AnyCodable

public protocol JSONRPCRequest: Encodable, Identifiable {
    associatedtype API      :JSONRPCAPI
    associatedtype Response
}

extension JSONRPCRequest where ID == Int {
    public var jsonRPC: String {
        API.version
    }
}

public struct Request<API: JSONRPCAPI, Response: Decodable>: JSONRPCRequest {
    private enum CodingKeys: String, CodingKey {
        case id, method, jsonRPC = "jsonrpc", parameters = "params"
    }
    
    init(_ method: String, parameters params: [Any] = [], id: ID = 1) {
        self.id         = id
        self.method     = "\(API.prefix)_\(method)"
        self.parameters = params
    }
    
    public let id         :Int
    public let method     :String
    public let parameters :[Any]

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(method, forKey: .method)
        try container.encode(jsonRPC, forKey: .jsonRPC)
        try container.encode(parameters.compactMap(AnyEncodable.init), forKey: .parameters)
    }
}

extension Request: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = Request(value, parameters: [AnyCodable]())
    }
}
