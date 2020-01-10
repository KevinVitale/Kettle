// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WalletKit",
    products: [
      .library(name: "WalletKit", type: .static, targets: ["WalletKit"]),
    ],
    dependencies: [
      .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .branch("master")),
      .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
    ],
    targets: [
      .target(name: "WalletKit", dependencies: [ 
          "BigInt",
          "CryptoSwift", 
          // "aes", 
          // "keccaktiny", 
          // "secp256k1" 
      ]),
      // .target(name: "aes"),
      // .target(name: "keccaktiny"),
      // .target(name: "secp256k1"),
      .testTarget(name: "WalletKitTests", dependencies: ["WalletKit"]),
    ]
)

