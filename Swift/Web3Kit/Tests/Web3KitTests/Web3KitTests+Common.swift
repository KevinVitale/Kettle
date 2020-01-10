import Web3Kit

// Conveniences for creating new clients --------------------------------------
extension ClientConfiguration {
    static let localNode  :ClientConfiguration = "http://192.168.1.111:8545"
    static let localHost  :ClientConfiguration = {
        #if !canImport(Darwin)
        return "http://kettle_ganache_1:8545"
        #else
        return "http://127.0.0.1:8545"
        #endif
    }()
}
