// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ForgeKit",
    products: [
        .library(
            name: "ForgeKit",
            targets: ["ForgeKit"]
        ),
    ],
    targets: [
        // ForgeKit deliberately declares no dependencies. The domain model and the
        // recommender must stay free of persistence and UI so they can be tested
        // in isolation and replaced without migration. See docs/decisions/.
        .target(
            name: "ForgeKit"
        ),
        .testTarget(
            name: "ForgeKitTests",
            dependencies: ["ForgeKit"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
