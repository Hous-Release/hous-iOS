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
      targets: ["HousUIComponent"]),
    .library(
      name: "HousButton",
      targets: ["HousButton"])
    // write your new module below
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
    .target(
      name: "HousUIComponent",
      dependencies: [
        "HousButton"
        // write your new module below
      ]),
    .testTarget(
      name: "HousUIComponentTests",
      dependencies: ["HousUIComponent"])
  ]
)
