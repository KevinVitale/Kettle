// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ContractKit",
    products: [
      .library(name: "ContractKit", type: .static, targets: ["ContractKit"]),
    ],
    dependencies: [
      .package(path: "../WalletKit"),
    ],
    targets: [
      .target(name: "ContractKit", dependencies: [ "WalletKit" ]),
      .testTarget(name: "ContractKitTests", dependencies: ["ContractKit"]),
    ]
)

