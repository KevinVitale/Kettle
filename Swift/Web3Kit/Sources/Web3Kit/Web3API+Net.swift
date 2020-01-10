extension JSONRPCRequest where API == Net {
    public static func version(id: Int = 1) -> API.Request<NetworkID> {
        API.Request("version", id: id)
    }
    
    public static func listening(id: Int = 1) -> API.Request<Bool> {
        API.Request("listening", id: id)
    }
    
    public static func peerCount(id: Int = 1) -> API.Request<String> {
        API.Request("peerCount", id: id)
    }
}
