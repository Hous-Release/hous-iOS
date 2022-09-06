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
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum Colors {
    internal static let black = ColorAsset(name: "Black")
    internal static let blue = ColorAsset(name: "Blue")
    internal static let blueL1 = ColorAsset(name: "Blue_l1")
    internal static let blueL2 = ColorAsset(name: "Blue_l2")
    internal static let g1 = ColorAsset(name: "G1")
    internal static let g2 = ColorAsset(name: "G2")
    internal static let g3 = ColorAsset(name: "G3")
    internal static let g4 = ColorAsset(name: "G4")
    internal static let g5 = ColorAsset(name: "G5")
    internal static let g6 = ColorAsset(name: "G6")
    internal static let g7 = ColorAsset(name: "G7")
    internal static let green = ColorAsset(name: "Green")
    internal static let purple = ColorAsset(name: "Purple")
    internal static let red = ColorAsset(name: "Red")
    internal static let white = ColorAsset(name: "White")
    internal static let yellow = ColorAsset(name: "Yellow")
  }
  internal enum Images {
    internal static let icHousCheck = ImageAsset(name: "ic_hous_check")
    internal static let icHousNocheck = ImageAsset(name: "ic_hous_nocheck")
    internal static let icProfileCheck = ImageAsset(name: "ic_profile_check")
    internal static let icProfileNocheck = ImageAsset(name: "ic_profile_nocheck")
    internal static let icTodoCheck = ImageAsset(name: "ic_todo_check")
    internal static let icTodoNocheck = ImageAsset(name: "ic_todo_nocheck")
    internal static let icCheckNo = ImageAsset(name: "ic_check_no")
    internal static let icCheckYes = ImageAsset(name: "ic_check_yes")
    internal static let icClose = ImageAsset(name: "ic_close")
    internal static let bg = ImageAsset(name: "bg")
    internal static let icCopy = ImageAsset(name: "ic_copy")
    internal static let icEditHous = ImageAsset(name: "ic_edit_hous")
    internal static let icMoreOurRules = ImageAsset(name: "ic_more_our_rules")
    internal static let profileBlue = ImageAsset(name: "profile_blue")
    internal static let profileBlueWtag = ImageAsset(name: "profile_blue_wtag")
    internal static let profileGreen = ImageAsset(name: "profile_green")
    internal static let profileGreenWtag = ImageAsset(name: "profile_green_wtag")
    internal static let profilePurple = ImageAsset(name: "profile_purple")
    internal static let profilePurpleWtag = ImageAsset(name: "profile_purple_wtag")
    internal static let profileRed = ImageAsset(name: "profile_red")
    internal static let profileRedWtag = ImageAsset(name: "profile_red_wtag")
    internal static let profileYellow = ImageAsset(name: "profile_yellow")
    internal static let profileYellowWtag = ImageAsset(name: "profile_yellow_wtag")
    internal static let icBack = ImageAsset(name: "ic_back")
    internal static let icAdd = ImageAsset(name: "ic_add")
    internal static let icMove1 = ImageAsset(name: "ic_move_1")
    internal static let frame1 = ImageAsset(name: "Frame 1")
    internal static let icBack1 = ImageAsset(name: "ic_back1")
    internal static let icMoreProfile = ImageAsset(name: "ic_more_profile")
    internal static let illCir = ImageAsset(name: "ill_cir")
    internal static let illHex = ImageAsset(name: "ill_hex")
    internal static let illPen = ImageAsset(name: "ill_pen")
    internal static let illSqu = ImageAsset(name: "ill_squ")
    internal static let illTri = ImageAsset(name: "ill_tri")
    internal static let icDoneInfo = ImageAsset(name: "ic_done_info")
    internal static let icDoneMy = ImageAsset(name: "ic_done_my")
    internal static let icDoneOur = ImageAsset(name: "ic_done_our")
    internal static let icHalfDoneInfo = ImageAsset(name: "ic_half_done_info")
    internal static let icHalfDoneOur = ImageAsset(name: "ic_half_done_our")
    internal static let icHelp = ImageAsset(name: "ic_help")
    internal static let icNoInfo = ImageAsset(name: "ic_no_info")
    internal static let icNoMy = ImageAsset(name: "ic_no_my")
    internal static let icNoOur = ImageAsset(name: "ic_no_our")
    internal static let btnAddFloating = ImageAsset(name: "btn_add_floating")
    internal static let icChange = ImageAsset(name: "ic_change")
    internal static let icChosen = ImageAsset(name: "ic_chosen")
    internal static let icBlueChosen = ImageAsset(name: "ic_blue_chosen")
    internal static let icDown = ImageAsset(name: "ic_down")
    internal static let icAlarmoff = ImageAsset(name: "ic_alarmoff")
    internal static let icAlarmon = ImageAsset(name: "ic_alarmon")
    internal static let icBlueNo = ImageAsset(name: "ic_blue_no")
    internal static let icBlueYes = ImageAsset(name: "ic_blue_yes")
    internal static let icGreenNo = ImageAsset(name: "ic_green_no")
    internal static let icGreenYes = ImageAsset(name: "ic_green_yes")
    internal static let icPurpleNo = ImageAsset(name: "ic_purple_no")
    internal static let icPurpleYes = ImageAsset(name: "ic_purple_yes")
    internal static let icRedNo = ImageAsset(name: "ic_red_no")
    internal static let icRedYes = ImageAsset(name: "ic_red_yes")
    internal static let icYellowNo = ImageAsset(name: "ic_yellow_no")
    internal static let icYellowYes = ImageAsset(name: "ic_yellow_yes")
    internal static let icDetailProfile = ImageAsset(name: "ic_detail_profile")
    internal static let icEditProfile = ImageAsset(name: "ic_edit_profile")
    internal static let icSetting = ImageAsset(name: "ic_setting")
    internal static let badgeLock = ImageAsset(name: "badge_lock")
    internal static let icBackWhite = ImageAsset(name: "ic_back_white")
    internal static let icCheckBadge = ImageAsset(name: "ic_check_badge")
    internal static let icBackTest = ImageAsset(name: "ic_back_test")
    internal static let icForTest = ImageAsset(name: "ic_for_test")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  #if os(iOS) || os(tvOS)
  @available(iOS 11.0, tvOS 11.0, *)
  internal func color(compatibleWith traitCollection: UITraitCollection) -> Color {
    let bundle = BundleToken.bundle
    guard let color = Color(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal private(set) lazy var swiftUIColor: SwiftUI.Color = {
    SwiftUI.Color(asset: self)
  }()
  #endif

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
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

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Color {
  init(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }
}
#endif

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
