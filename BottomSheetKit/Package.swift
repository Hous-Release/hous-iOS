// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BottomSheetKit",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "BottomSheetKit",
      targets: ["BottomSheetKit"]),
  ],
  dependencies: [
    .package(
      name: "ThirdPartyLibraryManager",
      path: "../ThirdPartyLibraryManager"
    )
  ],
  targets: [
    .target(
      name: "BottomSheetKit",
      dependencies: [
        .product(
          name: "ThirdPartyLibraryManager",
          package: "ThirdPartyLibraryManager"
        )
      ]),
    .testTarget(
      name: "BottomSheetKitTests",
      dependencies: ["BottomSheetKit"]),
  ]
)