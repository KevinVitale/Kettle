// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Web3Kit",
    products: [
      .library(name: "Web3Kit", type: .static, targets: ["Web3Kit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.2.3"),
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
        .package(url: "https://github.com/KevinVitale/Wei.git", from: "1.0.0"),
        .package(path: "../ContractKit"),
        .package(path: "../WalletKit"),
    ],
    targets: [
        .target(name: "Web3Kit", dependencies: [
            "AnyCodable",
            "BigInt",
            "ContractKit",
            "WalletKit",
            "Wei",
        ]),
        .testTarget(name: "Web3KitTests", dependencies: ["Web3Kit"]),
    ]
)

