public extension Client where API == Web3 {
    var bzz: Client<Bzz> { derivedClient() }
    var eth: Client<Eth> { derivedClient() }
    var net: Client<Net> { derivedClient() }
    var shh: Client<Shh> { derivedClient() }
}

public struct Web3 :JSONRPCAPI { public static let prefix :String = "web3" }
public struct Bzz  :JSONRPCAPI { public static let prefix :String = "bzz"  }
public struct Eth  :JSONRPCAPI { public static let prefix :String = "eth"  }
public struct Net  :JSONRPCAPI { public static let prefix :String = "net"  }
public struct Shh  :JSONRPCAPI { public static let prefix :String = "shh"  }

extension JSONRPCRequest where API == Web3 {
    public static func clientVersion(id: Int = 1) -> API.Request<String> {
        API.Request("clientVersion", id: id)
    }
    
    public static func sha3(data: String, id: Int = 1) -> API.Request<String> {
        API.Request("sha3", parameters: [data], id: id)
    }
}
