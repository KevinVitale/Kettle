import Foundation
import CryptoSwift

public enum SeedError: Swift.Error {
    case invalidMneumonic(usingWords: [String], withList: WordList)
}

public protocol MneumonicProtocol:
    Collection,
    ExpressibleByArrayLiteral
where Element: StringProtocol {
    
}

extension Array: MneumonicProtocol where Element: StringProtocol { }
extension String {
    public var mneumonic: Array<String.SubSequence> {
        split(separator: " ")
    }
}


extension MneumonicProtocol {
    public func seed(wordList: WordList = .english, passphrase: String = "") -> Result<Data, Error> {
        let mneumonic = map({ String($0) })
        guard mneumonic.contains(where: wordList.words.contains) else {
            return .failure(SeedError.invalidMneumonic(usingWords: mneumonic, withList: wordList))
        }
        
        return Result {
            let keyDerivation = try PKCS5.PBKDF2(
                password   :mneumonic.joined(separator: " ").bytes,
                salt       :("mneumonic" + passphrase).bytes,
                iterations :2048,
                keyLength  :32
            )
            return Data(try keyDerivation.calculate())
        }
    }
}
