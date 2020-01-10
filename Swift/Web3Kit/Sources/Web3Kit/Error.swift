import AnyCodable

/** TODO: Incomplete */
public struct JSONRPCError: Equatable, Decodable, Swift.Error {
    public let code    :AnyDecodable
    public let data    :AnyDecodable?
    public let message :String

    public static func ==(lhs: JSONRPCError, rhs: JSONRPCError) -> Bool {
        lhs.code == rhs.code
    }
}
