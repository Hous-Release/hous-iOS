// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "Network",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.6.1"),
        .package(name: "UserInformation", path: "../UserInformation")
    ],
    targets: [
        .target(
            name: "Network",
            dependencies: [
                "Alamofire",
                .product(name: "UserInformation", package: "UserInformation")
            ]),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]),
    ]
)
