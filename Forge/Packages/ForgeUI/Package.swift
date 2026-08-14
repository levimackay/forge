// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForgeUI",
    products: [
        .library(
            name: "ForgeUI",
            targets: ["ForgeUI"]
        ),
    ],
    dependencies: [
        .package(path: "../ForgeKit"),
    ],
    targets: [
        .target(
            name: "ForgeUI",
            dependencies: ["ForgeKit"]
        ),
        .testTarget(
            name: "ForgeUITests",
            dependencies: ["ForgeUI", "ForgeKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
