// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

import PackageDescription

let package = Package(
    name: "ThirdPartyLibraryManager",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "ThirdPartyLibraryManager",
            targets: ["ThirdPartyLibraryManager"]),
        .library(name: "Analytics", targets: ["Analytics"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.6.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", exact: "6.5.0"),
    ],
    targets: [
        .target(
            name: "ThirdPartyLibraryManager",
            dependencies: [
                "Alamofire",
                .product(name: "RxSwift", package: "Rxswift"),
                .product(name: "RxCocoa", package: "Rxswift"),
            ]
        ),
        .binaryTarget(name: "FBLPromises", path: "./Vender/FirebaseAnalytics/FBLPromises.xcframework"),
        .binaryTarget(name: "FirebaseAnalytics", path: "./Vender/FirebaseAnalytics/FirebaseAnalytics.xcframework"),
        .binaryTarget(name: "FirebaseAnalyticsSwift", path: "./Vender/FirebaseAnalytics/FirebaseAnalyticsSwift.xcframework"),
        .binaryTarget(name: "FirebaseCore", path: "./Vender/FirebaseAnalytics/FirebaseCore.xcframework"),
        .binaryTarget(name: "FirebaseCoreDiagnostics", path: "./Vender/FirebaseAnalytics/FirebaseCoreDiagnostics.xcframework"),
        .binaryTarget(name: "FirebaseCoreInternal", path: "./Vender/FirebaseAnalytics/FirebaseCoreInternal.xcframework"),
        .binaryTarget(name: "FirebaseInstallations", path: "./Vender/FirebaseAnalytics/FirebaseInstallations.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurement", path: "./Vender/FirebaseAnalytics/GoogleAppMeasurement.xcframework"),
        .binaryTarget(name: "GoogleAppMeasurementIdentitySupport", path: "./Vender/FirebaseAnalytics/GoogleAppMeasurementIdentitySupport.xcframework"),
        .binaryTarget(name: "GoogleDataTransport", path: "./Vender/FirebaseAnalytics/GoogleDataTransport.xcframework"),
        .binaryTarget(name: "GoogleUtilities", path: "./Vender/FirebaseAnalytics/GoogleUtilities.xcframework"),
        .binaryTarget(name: "nanopb", path: "./Vender/FirebaseAnalytics/nanopb.xcframework"),

        .target(
            name: "Analytics",
            dependencies: [
                .target(name: "FBLPromises"),
                .target(name: "FirebaseAnalytics"),
                .target(name: "FirebaseAnalyticsSwift"),
                .target(name: "FirebaseCore"),
                .target(name: "FirebaseCoreDiagnostics"),
                .target(name: "FirebaseCoreInternal"),
                .target(name: "FirebaseInstallations"),
                .target(name: "GoogleAppMeasurement"),
                .target(name: "GoogleAppMeasurementIdentitySupport"),
                .target(name: "GoogleDataTransport"),
                .target(name: "GoogleUtilities"),
                .target(name: "nanopb")
            ],
            resources: [
                .process("Resource")
            ]
        )
    ]
)
