// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AssetKit",
    products: [
        .library(
            name: "AssetKit",
            targets: ["AssetKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AssetKit",
            dependencies: [],
            resources: [.process("Resources"),
                        .process("Script")]
        ),
        .testTarget(
            name: "AssetKitTests",
            dependencies: ["AssetKit"]),
    ]
)
