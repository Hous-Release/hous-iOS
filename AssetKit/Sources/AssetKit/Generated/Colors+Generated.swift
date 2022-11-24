// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetColorTypeAlias = ColorAsset.Color

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Colors {
  public static let black = ColorAsset(name: "black")
  public static let blue = ColorAsset(name: "blue")
  public static let blueL1 = ColorAsset(name: "blueL1")
  public static let blueL2 = ColorAsset(name: "blueL2")
  public static let blueEdit = ColorAsset(name: "blueEdit")
  public static let g1 = ColorAsset(name: "g1")
  public static let g2 = ColorAsset(name: "g2")
  public static let g3 = ColorAsset(name: "g3")
  public static let g4 = ColorAsset(name: "g4")
  public static let g5 = ColorAsset(name: "g5")
  public static let g6 = ColorAsset(name: "g6")
  public static let g7 = ColorAsset(name: "g7")
  public static let green = ColorAsset(name: "green")
  public static let greenB1 = ColorAsset(name: "greenB1")
  public static let kakaoBrown = ColorAsset(name: "kakaoBrown")
  public static let kakaoYellow = ColorAsset(name: "kakaoYellow")
  public static let purple = ColorAsset(name: "purple")
  public static let purpleB1 = ColorAsset(name: "purpleB1")
  public static let red = ColorAsset(name: "red")
  public static let redB1 = ColorAsset(name: "redB1")
  public static let white = ColorAsset(name: "white")
  public static let yellow = ColorAsset(name: "yellow")
  public static let yellowB1 = ColorAsset(name: "yellowB1")
  public static let redL1 = ColorAsset(name: "redL1")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  public func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

//  #if canImport(SwiftUI)
//  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
//  public private(set) lazy var swiftUIColor: SwiftUI.Color = {
//    SwiftUI.Color(asset: self)
//  }()
//  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

//#if canImport(SwiftUI)
//@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
//public extension SwiftUI.Color {
//  init(asset: ColorAsset) {
//    let bundle = BundleToken.bundle
//    self.init(asset.name, bundle: bundle)
//  }
//}
//#endif

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
