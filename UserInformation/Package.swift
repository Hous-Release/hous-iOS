// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserInformation",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "UserInformation",
            targets: ["UserInformation"]),
    ],
    dependencies: [
      .package(name: "ThirdPartyLibraryManager", path: "../ThirdPartyLibraryManager")
    ],
    targets: [
        .target(
            name: "UserInformation",
            dependencies: [
              .product(name: "ThirdPartyLibraryManager", package: "ThirdPartyLibraryManager")
            ]),
        .testTarget(
            name: "UserInformationTests",
            dependencies: ["UserInformation"]),
    ]
)
