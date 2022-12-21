// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .library(
            name: "FirebaseWrapper",
            targets: ["FirebaseWrapper"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.6.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", exact: "6.5.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", exact: "4.0.4"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", exact: "5.0.2"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.6.0"),
        .package(url: "https://github.com/devxoul/Then.git", exact: "3.0.0"),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git", exact: "3.2.0"),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper", revision: "185a3165346a03767101c4f62e9a545a0fe0530f"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", branch: "master"),
        .package(url: "https://github.com/airbnb/lottie-ios", revision: "3cf8ade4f14cb67fd06ee760e9b579eeb9ea31fb"),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", revision: "d8d4e53d05239f1ec1bd8bec173907868afa0fa1"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", exact: "2.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", branch: "master"),
        .package(url: "https://github.com/RxSwiftCommunity/RxReachability", .upToNextMajor(from: "1.2.1")),
    ],
    targets: [
        .target(
            name: "ThirdPartyLibraryManager",
            dependencies: [
                "Alamofire",
                .product(name: "RxSwift", package: "Rxswift"),
                .product(name: "RxCocoa", package: "Rxswift"),
                .product(name: "RxGesture", package: "RxGesture"),
                .product(name: "RxDataSources", package: "RxDataSources"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "Then", package: "Then"),
                .product(name: "ReactorKit", package: "ReactorKit"),
                .product(name: "SwiftKeychainWrapper", package: "SwiftKeychainWrapper"),
                .product(name: "KakaoSDKCommon", package: "kakao-ios-sdk"),
                .product(name: "KakaoSDKAuth", package: "kakao-ios-sdk"),
                .product(name: "KakaoSDKUser", package: "kakao-ios-sdk"),
                .product(name: "Lottie", package: "lottie-ios"),
                .product(name: "RxFlow", package: "RxFlow"),
                .product(name: "RxKeyboard", package: "RxKeyboard"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "RxReachability", package: "RxReachability"),
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
        .binaryTarget(name: "FirebaseMessaging", path: "./Vender/FirebaseMessaging/FirebaseMessaging.xcframework"),

        .target(
            name: "FirebaseWrapper",
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
                .target(name: "nanopb"),
                .target(name: "FirebaseMessaging"),
            ],
            resources: [
//                .process("Resource/"),
                .copy("Resource/")
            ]
        ),
    ]
)
