import XCTest
import WalletKit
import BigInt

final class WalletKitTests: XCTestCase {
    func testChinese() throws {
        XCTAssertEqual(WordList.chinese.words.count, 2048)
    }
    
    func testEnglish() throws {
        XCTAssertEqual(WordList.english.words.count, 2048)
    }

    func testJapanese() throws {
        XCTAssertEqual(WordList.japanese.words.count, 2048)
    }
    
    func testMneumonicGeneratorTest() throws {
        MneumonicGenerator.Strength.allValues.forEach {
            let mneumonic = MneumonicGenerator.mneumonic(withStrength: $0)
            print("String: \($0.rawValue) (\(mneumonic.count)):", mneumonic, terminator: "\n")
        }
    }
    
    func testSeedGeneration() throws {
        let seed = "clarify lunar believe enact adjust drama purity tape lawn patrol crouch pond"
            .mneumonic
            .seed(wordList: .english)
        switch seed {
        case .failure(let error) : print("\(error)")
        case .success(let data)  : print(data.toHexString())
        }
    }
}
