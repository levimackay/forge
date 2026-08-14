// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForgeData",
    products: [
        .library(
            name: "ForgeData",
            targets: ["ForgeData"]
        ),
    ],
    dependencies: [
        .package(path: "../ForgeKit"),
    ],
    targets: [
        .target(
            name: "ForgeData",
            dependencies: ["ForgeKit"]
        ),
        .testTarget(
            name: "ForgeDataTests",
            dependencies: ["ForgeData", "ForgeKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
