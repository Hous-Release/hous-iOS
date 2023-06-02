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
      targets: [
        "HousUIComponent"
      ]
    )
  ],
  dependencies: [
    .package(name: "AssetKit", path: "../AssetKit"),
    .package(name: "ThirdPartyLibraryManager", path: "../ThirdPartyLibraryManager")
  ],
  targets: [
    .target(
      name: "HousUIComponent",
      dependencies: [
        .product(name: "AssetKit", package: "AssetKit"),
        .product(name: "ThirdPartyLibraryManager", package: "ThirdPartyLibraryManager")
      ]),
    .testTarget(
      name: "HousUIComponentTests",
      dependencies: ["HousUIComponent"])
  ]
)
