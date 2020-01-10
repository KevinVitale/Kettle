import Foundation
import CryptoSwift

/// https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki
public struct MneumonicGenerator {
    public enum Strength: Int {
        case _128 = 128
        case _160 = 160
        case _192 = 192
        case _224 = 224
        case _256 = 256
        
        public static var allValues: [Strength] {
            [
                ._128,
                ._160,
                ._192,
                ._224,
                ._256,
            ]
        }

        fileprivate var randomBytes: Data {
            .randomBytes(rawValue / 8)
        }
    }
    
    public static func mneumonic(withStrength strength: Strength = ._128, fromWords list: WordList = .english) -> [String] {
        mneumonic(fromEntropy: strength.randomBytes, fromWords: list)
    }
    
    public static func mneumonic(fromEntropy data: Data, fromWords list: WordList = .english) -> [String] {
        let concatenatedBits = data.concatenatedBits()
        let words = list.words
        
        var mnemonic: [String] = []
        for index in 0..<(concatenatedBits.count / 11) {
            let startIndex = concatenatedBits.index(concatenatedBits.startIndex, offsetBy: index * 11)
            let endIndex = concatenatedBits.index(startIndex, offsetBy: 11)
            let wordIndex = Int(strtoul(String(concatenatedBits[startIndex..<endIndex]), nil, 2))
            mnemonic.append(String(words[wordIndex]))
        }
        
        return mnemonic
    }
}

private extension Data {
    /// https://github.com/D-Technologies/EthereumKit/blob/master/EthereumKit/Mnemonic/Mnemonic.swift#L17
    func concatenatedBits() -> String {
        let entropyBits = String(flatMap { ("00000000" + String($0, radix: 2)).suffix(8) })
        let hashBits    = String(sha256().flatMap { ("00000000" + String($0, radix: 2)).suffix(8) })
        let checkSum    = String(hashBits.prefix((count * 8) / 32))
        return (entropyBits + checkSum)
    }
}

fileprivate extension Data {
    static func randomBytes(_ count: Int) -> Data {
        return Data((0...count).map { _ in
            UInt8.random(in: 0...UInt8.max)
        })
    }
}
