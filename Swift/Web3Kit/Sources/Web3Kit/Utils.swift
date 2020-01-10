import Foundation
import CryptoSwift

internal func waitFor<T,ErrorType>(_ body: (@escaping (Result<T,ErrorType>) -> Void) -> Void) -> Result<T,Swift.Error> {
    Result { try await(body) }
}

extension StringProtocol {
    fileprivate func dropHexPrefix() -> Self.SubSequence {
        self.hasPrefix("0x") ? self.dropFirst(2) : self.dropFirst(0)
    }
}

// https://stackoverflow.com/a/46663290
extension Data {
    fileprivate init?<S: StringProtocol>(hexString: S) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}

extension Data {
    fileprivate func hexString(prefix: String = "", separator: String = "", radix: Int = 16) -> String {
        prefix + map { String($0, radix: radix, uppercase: true) }.joined(separator: separator).lowercased()
    }
    
    fileprivate var keccak256: Data {
        Data(bytes: self.map({ $0 }).sha3(.keccak256), count: 32)
    }
}

import BigInt
public protocol ExpressibleByPrefixedHexString {
    init?<S: StringProtocol>(hex: S)
}

extension Array where Element: StringProtocol {
    public func cast<S: ExpressibleByPrefixedHexString>(to: S.Type) -> [S] {
        compactMap(S.init)
    }
}

extension BigUInt: ExpressibleByPrefixedHexString {
    public init?<S: StringProtocol>(hex: S) {
        self.init(hex.dropHexPrefix(), radix: 16)
    }
}

extension BigInt: ExpressibleByPrefixedHexString {
    public init?<S: StringProtocol>(hex: S) {
        self.init(hex.dropHexPrefix(), radix: 16)
    }
}

extension UInt: ExpressibleByPrefixedHexString {
    public init?<S: StringProtocol>(hex: S) {
        self.init(hex.dropHexPrefix(), radix: 16)
    }
}

extension Int: ExpressibleByPrefixedHexString {
    public init?<S: StringProtocol>(hex: S) {
        self.init(hex.dropHexPrefix(), radix: 16)
    }
}
