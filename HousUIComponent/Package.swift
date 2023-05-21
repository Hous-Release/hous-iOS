// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "HousUIComponent",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "HousUIComponent",
      targets: ["HousButton"])
  ],
  dependencies: [
    .package(
      name: "AssetKit",
      path: "../AssetKit"
    )
  ],
  targets: [
    .target(
      name: "HousButton",
      dependencies: [
        .product(
          name: "AssetKit",
          package: "AssetKit"
        )
      ]),
    .testTarget(
      name: "HousUIComponentTests",
      dependencies: ["HousButton"])
  ]
)
