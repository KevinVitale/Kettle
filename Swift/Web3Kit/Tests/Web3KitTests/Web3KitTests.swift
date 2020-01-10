import XCTest
import Web3Kit
import BigInt
import AnyCodable
import WalletKit
import Wei

final class Web3KitTests: XCTestCase {
    static let allTests = [
        ("testGetBalances", testGetBalances),
        ("testSendTransaction", testSendTransaction),
    ]

    func testGetBalances() throws {
        let web3 = Client<Web3>(.localHost)
        
        let accounts = (try? web3.eth(request: .accounts()).get())?.result ?? []
        let balances = (try? web3.eth(request: Eth.AnyRequest.getBalances(addresses: accounts)).get())?.result
        
        balances?
            .compactMap({ $0?(as: .wei).to(.ether) })
            .enumerated()
            .map({ (accounts[$0.0], $0.1) })
            .forEach {
                print($0)
        }
    }
    
    
    
    func testSendTransaction() {
        /*
        let group = DispatchGroup()
        let web3 = Client<Web3>(.localHost)
        
        group.enter()
        DispatchQueue.global().async {
            let receipt = waitFor {
                web3.eth(request: "blockNumber", callback: $0)
            }
            .map { _ in
                [
                    "to"       :"0x0cbe55df6ec0b2ad41274dad7ccf17fc632cf749",
                    "from"     :"0x3e07d9AE4662CA5A541746Be369354DDAE09903C",
                    "value"    :1(as: .ether).hexString,
                ]
            }
            .flatMap { transation in
                waitFor {
                    web3.eth(
                        request: "sendTransaction",
                        parameters: [transation],
                        callback: $0
                    )
                }
                .cast(to: String.self)
                .flatMap { txHash in
                    waitFor {
                        web3.eth(request: "getTransactionReceipt", parameters: [txHash ?? ""], callback: $0)
                    }
                }
                .cast(to: [String:Any].self)
            }
            
            switch receipt {
            case .failure(let error)   :print(error)
            case .success(let result?) :
                let receipt = result
                    .enumerated()
                    .sorted { $0.element.key < $1.element.key }
                receipt.forEach {
                    print("\t\($0.element.key):\r\t\t\($0.element.value)\r")
                }
                if let gasUsed = result["gasUsed"] as? String {
                    print("Gas Used: \(gasUsed(as: .gas))")
                }
            default: (/* no-op */)
            }
            group.leave()
        }
        group.wait()
         */
    }

    
    
    
    
    
    
    
    
    
    
    
    /*
func testExample() throws {
    // Create some clients ---------------------------------------------------------
    let web3   = Client<Web3>(.localHost)
    
    // Misc. app state -------------------------------------------------------------
    let group       = DispatchGroup()
    
    // Begin sending requests ------------------------------------------------------
    group.enter()
    web3.net(request: .version()) {
        defer { group.leave() }
        
        if let network = try? $0.get().result {
            print(network)
        }
    }
    
    group.enter()
    web3.net(request: "listening", "version") { _ in
        group.leave()
    }
    
    group.enter()
    web3.eth(request: .syncing(id: 1)) {
        defer { group.leave() }
        do {
            print(try $0.get().result!)
        }
        catch {
            print($0)
        }
    }
    
    group.enter()
    web3.eth(request: .transactionCount(byHash: "0x2")) {
        defer { group.leave() }
        switch $0.cast(to: BigUInt.self) {
        case .failure(let error): print(error)
        case .success(let blockNumber): print(blockNumber)
        }
    }
    
    group.enter()
    web3.eth(request: .transactionCount(forBlock: "latest")) {
        defer { group.leave() }
        switch $0.cast(to: BigUInt.self) {
        case .failure(let error): print(error)
        case .success(let blockNumber): print(blockNumber)
        }
    }
    
    group.enter()
    web3.eth(request: .transactionCount(forBlock: 9301515)) {
        defer { group.leave() }
        switch $0.cast(to: BigUInt.self) {
        case .failure(let error): print(error)
        case .success(let blockNumber): print(blockNumber)
        }
    }
    
    group.enter()
    web3.eth(request: .sign(address: "0x9b2055d370f73ec7d8a03e965129118dc8f5bf83", message: "0xdeadbeef")) {
        defer { group.leave() }
        if let result = try? $0.get().result {
            XCTAssertEqual(result, "0xa3f20717a250c2b0b729b7e5becbff67fdaef7e0699da4de7ca5895b02a170a12d887fd3b17bfdce3481f10bea41f45ba9f709d39ce8325427b57afcfc994cee1b")
        }
    }
    
    group.enter()
    web3.eth(request: "sign", parameters: ["0x3e07d9AE4662CA5A541746Be369354DDAE09903C", "hello, world"], id: 1) {
        if let result = try? $0.get().result?.value as? String {
            web3.eth(request: "getTransactionReceipt", parameters: [result]) {
                defer { group.leave() }
                if let result = try? $0.get().result {
                    print("Result: \(result)")
                }
            }
        }
    }
    group.wait()
}
    
    func testTransactionCount() {
        let group = DispatchGroup()
        let web3 = Client<Web3>(.localNode)

        group.enter()
        web3.eth(request: .transactionCount(forBlock: "latest")) {
            defer { group.leave() }
            switch $0.cast(to: BigUInt.self) {
            case .failure(let error): print(error)
            case .success(let count): print(count)
            }
        }
        
        group.wait()
    }
    
    func testBlockNumber() {
        let group = DispatchGroup()
        let web3 = Client<Web3>(.localNode)
        
        group.enter()
        web3.eth(request: .blockNumber()) {
            defer { group.leave() }
            switch $0.cast(to: BigUInt.self) {
            case .failure(let error): print(error)
            case .success(let blockNumber): print(blockNumber)
            }
        }
        
        group.wait()
    }
     */
}
