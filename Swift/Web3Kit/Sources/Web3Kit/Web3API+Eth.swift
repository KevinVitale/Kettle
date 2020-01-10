import BigInt

extension Eth {
    public enum Syncing: Decodable, Equatable {
        case isSyncing(State)
        case isNot
        
        public init(from decoder: Decoder) throws {
            guard let _ = try? decoder.container(keyedBy: State.CodingKeys.self) else {
                self = .isNot
                return
            }
            
            self = .isSyncing(try State(decode: decoder))
        }
        
        public static func == (lhs: Eth.Syncing, rhs: Eth.Syncing) -> Bool {
            switch (lhs, rhs) {
            case (.isNot, .isNot): return true
            case (.isSyncing(let state1), .isSyncing(let state2)): return state1 == state2
            default: return false
            }
        }
        
        
        public struct State: Decodable, Equatable {
            enum CodingKeys: String, CodingKey {
                case startingBlock, currentBlock, highestBlock
            }
            
            let startingBlock :BigUInt
            let currentBlock  :BigUInt
            let highestBlock  :BigUInt
            
            init(decode decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.startingBlock = BigUInt(hex: try container.decode(String.self, forKey: .startingBlock))!
                self.currentBlock  = BigUInt(hex: try container.decode(String.self, forKey: .currentBlock))!
                self.highestBlock  = BigUInt(hex: try container.decode(String.self, forKey: .highestBlock))!
            }
        }
    }
}

extension JSONRPCRequest where API == Eth {
    public static func protocolVersion(id: Int = 1) -> API.Request<String> {
        API.Request("protocolVersion", id: id)
    }
    
    public static func syncing(id: Int = 1) -> API.Request<API.Syncing> {
        API.Request("syncing", id: id)
    }
    
    public static func coinbase(id: Int = 1) -> API.Request<String> {
        API.Request("coinbase", id: id)
    }
    
    public static func mining(id: Int = 1) -> API.Request<Bool> {
        API.Request("mining", id: id)
    }
    
    public static func hashrate(id: Int = 1) -> API.Request<String> {
        API.Request("hashrate", id: id)
    }
    
    public static func gasPrice(id: Int = 1) -> API.Request<String> {
        API.Request("gasPrice", id: id)
    }

    public static func accounts(id: Int = 1) -> API.Request<[String]> {
        API.Request("accounts", id: id)
    }
    
    public static func blockNumber(id: Int = 1) -> API.Request<String> {
        API.Request("blockNumber", id: id)
    }
    
    public static func block<S: StringProtocol>(forNumber blockNumber: S, id: Int = 1) -> API.Request<[String:String]> {
        API.Request("getBlockByNumber", parameters: [blockNumber, true], id: id)
    }

    public static func block<I: BinaryInteger>(byNumber blockNumber: I, id: Int = 1) -> API.Request<[String:String]> {
        API.Request("getBlockByNumber", parameters: ["0x\(String(blockNumber, radix: 16))", true], id: id)
    }
    
    public static func getBalance<S: StringProtocol>(address: S, blockNumber: String = "latest", id: Int = 1) -> API.Request<String> {
        API.Request("getBalance", parameters: [address, blockNumber], id: id)
    }

    public static func getStorage(atAddress address: String, blockNumber: String = "latest", id: Int = 1) -> API.Request<String> {
        fatalError("Not yet implemented")
    }
    
    public static func transactionCount(sentBy address: String, blockNumber: String = "latest", id: Int = 1) -> API.Request<String> {
        API.Request("getTransactionCount", parameters: [address, blockNumber], id: id)
    }
    
    public static func transactionCount<I: BinaryInteger>(sentBy address: String, blockNumber: I, id: Int = 1) -> API.Request<String> {
        API.Request("getTransactionCount", parameters: [address, "0x\(String(blockNumber, radix: 16))"], id: id)
    }
    
    public static func transactionCount(byHash blockHash: String, id: Int = 1) -> API.Request<String> {
        API.Request("getBlockTransactionCountByHash", parameters: [blockHash], id: id)
    }

    public static func transactionCount<S: StringProtocol>(forBlock blockNumber: S, id: Int = 1) -> API.Request<String> {
        API.Request("getBlockTransactionCountByNumber", parameters: [blockNumber], id: id)
    }
    
    public static func transactionCount<I: BinaryInteger>(forBlock blockNumber: I, id: Int = 1) -> API.Request<String> {
        API.Request("getBlockTransactionCountByNumber", parameters: ["0x\(String(blockNumber, radix: 16))"], id: id)
    }

    public static func sign(address: String, message: String, id: Int = 1) -> API.Request<String> {
        API.Request("sign", parameters: [address, message], id: id)
    }
    
    public static func receipt<R: Decodable>(forTransaction transaction: String, id: Int = 1) -> API.Request<R> {
        API.Request("getTransactionReceipt", parameters: [transaction], id: id)
    }
}

extension JSONRPCRequest where API == Eth {
    public static func getBalances<S: StringProtocol>(addresses: S..., blockNumber: String = "latest") -> API.BatchRequest<String> {
        addresses.enumerated().map {
            API.Request("getBalance", parameters: [$0.element, blockNumber], id: $0.offset)
        }
    }

    public static func getBalances(addresses: [String], blockNumber: String = "latest") -> API.BatchRequest<String> {
        addresses.enumerated().map {
            API.Request("getBalance", parameters: [$0.element, blockNumber], id: $0.offset)
        }
    }
}
