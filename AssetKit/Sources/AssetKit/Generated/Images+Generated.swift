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
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
public typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
public enum Images {
  public static let icHousCheck = ImageAsset(name: "ic_hous_check")
  public static let icHousNocheck = ImageAsset(name: "ic_hous_nocheck")
  public static let icProfileCheck = ImageAsset(name: "ic_profile_check")
  public static let icProfileNocheck = ImageAsset(name: "ic_profile_nocheck")
  public static let icTodoCheck = ImageAsset(name: "ic_todo_check")
  public static let icTodoNocheck = ImageAsset(name: "ic_todo_nocheck")
  public static let notconnected = ImageAsset(name: "Notconnected")
  public static let invalidName = ImageAsset(name: "invalidName")
  public static let icCheckNo = ImageAsset(name: "ic_check_no")
  public static let icCheckYes = ImageAsset(name: "ic_check_yes")
  public static let illOnboarding01 = ImageAsset(name: "ill_onboarding_01")
  public static let illOnboarding02 = ImageAsset(name: "ill_onboarding_02")
  public static let illOnboarding03 = ImageAsset(name: "ill_onboarding_03")
  public static let illOnboarding04 = ImageAsset(name: "ill_onboarding_04")
  public static let icCheckNotOnboardSetting = ImageAsset(name: "ic_check_not_onboard_setting")
  public static let icCheckYesOnboardSetting = ImageAsset(name: "ic_check_yes_onboard_setting")
  public static let icStarOff = ImageAsset(name: "ic_star_off")
  public static let icStarOn = ImageAsset(name: "ic_star_on")
  public static let resign = ImageAsset(name: "resign")
  public static let icSettingGrey = ImageAsset(name: "ic_setting_grey")
  public static let illDone = ImageAsset(name: "ill_done")
  public static let illMakeroom = ImageAsset(name: "ill_makeroom")
  public static let illEnterroom = ImageAsset(name: "ill_enterroom")
  public static let illGo = ImageAsset(name: "ill_go")
  public static let icClose = ImageAsset(name: "ic_close")
  public static let bg = ImageAsset(name: "bg")
  public static let icCopy = ImageAsset(name: "ic_copy")
  public static let icEditHous = ImageAsset(name: "ic_edit_hous")
  public static let icMoreOurRules = ImageAsset(name: "ic_more_our_rules")
  public static let noBadgeProfile = ImageAsset(name: "no_badge_profile")
  public static let profileBlue = ImageAsset(name: "profile_blue")
  public static let profileBlueWtag = ImageAsset(name: "profile_blue_wtag")
  public static let profileGreen = ImageAsset(name: "profile_green")
  public static let profileGreenWtag = ImageAsset(name: "profile_green_wtag")
  public static let profileNone = ImageAsset(name: "profile_none")
  public static let profilePurple = ImageAsset(name: "profile_purple")
  public static let profilePurpleWtag = ImageAsset(name: "profile_purple_wtag")
  public static let profileRed = ImageAsset(name: "profile_red")
  public static let profileRedWtag = ImageAsset(name: "profile_red_wtag")
  public static let profileYellow = ImageAsset(name: "profile_yellow")
  public static let profileYellowWtag = ImageAsset(name: "profile_yellow_wtag")
  public static let icBack = ImageAsset(name: "ic_back")
  public static let icAdd = ImageAsset(name: "ic_add")
  public static let illLimit = ImageAsset(name: "ill_limit")
  public static let icDot4 = ImageAsset(name: "icDot4")
  public static let icCheck2 = ImageAsset(name: "ic_check2")
  public static let icMove1 = ImageAsset(name: "ic_move_1")
  public static let frame1 = ImageAsset(name: "Frame 1")
  public static let icBack1 = ImageAsset(name: "ic_back1")
  public static let icMoreProfile = ImageAsset(name: "ic_more_profile")
  public static let illCir = ImageAsset(name: "ill_cir")
  public static let illHex = ImageAsset(name: "ill_hex")
  public static let illPen = ImageAsset(name: "ill_pen")
  public static let illSqu = ImageAsset(name: "ill_squ")
  public static let illTri = ImageAsset(name: "ill_tri")
  public static let icDoneInfo = ImageAsset(name: "ic_done_info")
  public static let icDoneMy = ImageAsset(name: "ic_done_my")
  public static let icDoneOur = ImageAsset(name: "ic_done_our")
  public static let icHalfDoneInfo = ImageAsset(name: "ic_half_done_info")
  public static let icHalfDoneOur = ImageAsset(name: "ic_half_done_our")
  public static let icHelp = ImageAsset(name: "ic_help")
  public static let icNoInfo = ImageAsset(name: "ic_no_info")
  public static let icNoMy = ImageAsset(name: "ic_no_my")
  public static let icNoOur = ImageAsset(name: "ic_no_our")
  public static let icProgressbar = ImageAsset(name: "ic_progressbar")
  public static let btnAddFloating = ImageAsset(name: "btn_add_floating")
  public static let icChange = ImageAsset(name: "ic_change")
  public static let icChosen = ImageAsset(name: "ic_chosen")
  public static let dotTodobymem = ImageAsset(name: "dot_todobymem")
  public static let icBlueChosen = ImageAsset(name: "ic_blue_chosen")
  public static let icBlueUnchosen = ImageAsset(name: "ic_blue_unchosen")
  public static let icDown = ImageAsset(name: "ic_down")
  public static let icGreenChosen = ImageAsset(name: "ic_green_chosen")
  public static let icGreenUnchosen = ImageAsset(name: "ic_green_unchosen")
  public static let icGreyChosen = ImageAsset(name: "ic_grey_chosen")
  public static let icGreyUnchosen = ImageAsset(name: "ic_grey_unchosen")
  public static let icNoneChosen = ImageAsset(name: "ic_none_chosen")
  public static let icNoneUnchosen = ImageAsset(name: "ic_none_unchosen")
  public static let icPurpleChosen = ImageAsset(name: "ic_purple_chosen")
  public static let icPurpleUnchosen = ImageAsset(name: "ic_purple_unchosen")
  public static let icRedChosen = ImageAsset(name: "ic_red_chosen")
  public static let icRedUnchosen = ImageAsset(name: "ic_red_unchosen")
  public static let icYellowChosen = ImageAsset(name: "ic_yellow_chosen")
  public static let icYellowUnchosen = ImageAsset(name: "ic_yellow_unchosen")
  public static let icCheckMember = ImageAsset(name: "ic_check_member")
  public static let icAlarmoff = ImageAsset(name: "ic_alarmoff")
  public static let icAlarmon = ImageAsset(name: "ic_alarmon")
  public static let icBlueNo = ImageAsset(name: "ic_blue_no")
  public static let icBlueYes = ImageAsset(name: "ic_blue_yes")
  public static let icGrayNo = ImageAsset(name: "ic_gray_no")
  public static let icGrayYes = ImageAsset(name: "ic_gray_yes")
  public static let icGreenNo = ImageAsset(name: "ic_green_no")
  public static let icGreenYes = ImageAsset(name: "ic_green_yes")
  public static let icPurpleNo = ImageAsset(name: "ic_purple_no")
  public static let icPurpleYes = ImageAsset(name: "ic_purple_yes")
  public static let icRedNo = ImageAsset(name: "ic_red_no")
  public static let icRedYes = ImageAsset(name: "ic_red_yes")
  public static let icYellowNo = ImageAsset(name: "ic_yellow_no")
  public static let icYellowYes = ImageAsset(name: "ic_yellow_yes")
  public static let icAlarm = ImageAsset(name: "ic_alarm")
  public static let icAlarmEmpty = ImageAsset(name: "ic_alarm_empty")
  public static let icCheckBlue = ImageAsset(name: "ic_check_blue")
  public static let icCheckGreen = ImageAsset(name: "ic_check_green")
  public static let icCheckPurple = ImageAsset(name: "ic_check_purple")
  public static let icCheckRed = ImageAsset(name: "ic_check_red")
  public static let icCheckYellow = ImageAsset(name: "ic_check_yellow")
  public static let icDetailProfile = ImageAsset(name: "ic_detail_profile")
  public static let icEditProfile = ImageAsset(name: "ic_edit_profile")
  public static let icSetting = ImageAsset(name: "ic_setting")
  public static let icSettingEmpty = ImageAsset(name: "ic_setting_empty")
  public static let icShow = ImageAsset(name: "ic_show")
  public static let icShowOn = ImageAsset(name: "ic_show_on")
  public static let illByebye = ImageAsset(name: "ill_byebye")
  public static let illNocharacter = ImageAsset(name: "ill_nocharacter")
  public static let noBadge = ImageAsset(name: "no_badge")
  public static let badgeLock = ImageAsset(name: "badge_lock")
  public static let badgeStar = ImageAsset(name: "badge_star")
  public static let icBackWhite = ImageAsset(name: "ic_back_white")
  public static let icCheckBadge = ImageAsset(name: "ic_check_badge")
  public static let lockBg = ImageAsset(name: "lock_bg")
  public static let star = ImageAsset(name: "star")
  public static let icLeft = ImageAsset(name: "ic_left")
  public static let icLeftOn = ImageAsset(name: "ic_left_on")
  public static let icRight = ImageAsset(name: "ic_right")
  public static let icRightOn = ImageAsset(name: "ic_right_on")
  public static let illTeststart = ImageAsset(name: "illTeststart")
  public static let bottomGradient = ImageAsset(name: "bottom_gradient")
  public static let icAlarmSetting = ImageAsset(name: "ic_alarm_setting")
  public static let icFeedback = ImageAsset(name: "ic_feedback")
  public static let icInfo = ImageAsset(name: "ic_info")
  public static let icNext = ImageAsset(name: "ic_next")
  public static let icSettingRadioDisable = ImageAsset(name: "ic_setting_radio_disable")
  public static let icSettingRadioOff = ImageAsset(name: "ic_setting_radio_off")
  public static let icSettingRadioOn = ImageAsset(name: "ic_setting_radio_on")
  public static let icNotiBadge = ImageAsset(name: "ic_noti_Badge")
  public static let icNotiRules = ImageAsset(name: "ic_noti_rules")
  public static let icNotiTodo = ImageAsset(name: "ic_noti_todo")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  public var image: Image {
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
  public func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  public var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

public extension ImageAsset.Image {
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
public extension SwiftUI.Image {
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
