//
//  File.swift
//  
//
//  Created by 김지현 on 2023/05/21.
//

import UIKit
import AssetKit

protocol ButtonCommonProtocol {
  var activeBackgroundColor: UIColor? { get }
  var disabledBackgroundColor: UIColor? { get }
  var activeTitleColor: UIColor? { get }
  var disabledTitleColor: UIColor? { get }
  var title: String { get }
}

protocol CheckButtonProtocol {
  var selectedCheckImage: UIImage { get }
  var unselectedCheckImage: UIImage { get }
}

public enum Button {

  public enum Onboarding {
    case next, createRoom, enterRoom, start, toStart, leaveProfile
  }

  public enum Basic {
    case kakao, apple, save, retry
  }

  public enum Check {
    case confirmRemoveProfile, comfirmFeedback, enableNotification
  }

  public enum Filter {
    case def
  }
}



extension Button.Onboarding: ButtonCommonProtocol {
  var activeBackgroundColor: UIColor? {
    switch self {
    case .next, .createRoom, .enterRoom, .start, .toStart:
      return Colors.blue.color
    case .leaveProfile:
      return Colors.red.color
    }
  }

  var disabledBackgroundColor: UIColor? {
    switch self {
    case .next, .createRoom, .enterRoom, .start, .toStart:
      return Colors.g4.color
    case .leaveProfile:
      return Colors.redB1.color
    }
  }

  var activeTitleColor: UIColor? {
    return Colors.white.color
  }

  var disabledTitleColor: UIColor? { return nil }

  var title: String {
    switch self {
    case .next:
      return "다음으로"
    case .createRoom:
      return "방 만들기"
    case .enterRoom:
      return "방 참여하기"
    case .start:
      return "시작하기"
    case .toStart:
      return "처음으로"
    case .leaveProfile:
      return "탈퇴하기"
    }
  }
}

extension Button.Basic: ButtonCommonProtocol {

  var activeBackgroundColor: UIColor? {
    switch self {
    case .kakao:
      return Colors.kakaoYellow.color
    case .apple:
      return Colors.black.color
    case .save:
      return Colors.black.color
    case .retry:
      return Colors.blue.color
    }
  }

  var disabledBackgroundColor: UIColor? { return nil }

  var activeTitleColor: UIColor? {
    switch self {
    case .kakao:
      return Colors.kakaoBrown.color
    case .apple, .save, .retry:
      return Colors.white.color
    }
  }

  var disabledTitleColor: UIColor? { return nil }

  var title: String {
    switch self {
    case .kakao:
      return "카카오톡으로 계속하기"
    case .apple:
      return "Apple로 계속하기"
    case .save:
      return "저장하기"
    case .retry:
      return "다시 검사하기"
    }
  }
}

extension Button.Check: ButtonCommonProtocol  {
  var activeBackgroundColor: UIColor? { return nil }

  var disabledBackgroundColor: UIColor? { return nil }

  var activeTitleColor: UIColor? {
    switch self {
    case .confirmRemoveProfile:
      return Colors.red.color
    case .comfirmFeedback:
      return Colors.blue.color
    case .enableNotification:
      return Colors.blue.color
    }
  }

  var disabledTitleColor: UIColor? {
    switch self {
    case .confirmRemoveProfile:
      return Colors.redB1.color
    case .comfirmFeedback:
      return Colors.blueL1.color
    case .enableNotification:
      return Colors.g4.color
    }
  }

  var title: String {
    switch self {
    case .confirmRemoveProfile:
      return "탈퇴하겠습니다"
    case .comfirmFeedback:
      return "동의합니다."
    case .enableNotification:
      return "알림 받기"
    }
  }
}

extension Button.Check: CheckButtonProtocol {
  var selectedCheckImage: UIImage {
    switch self {
    case .confirmRemoveProfile:
      return Images.icCheckYesOnboardSetting.image
    case .comfirmFeedback:
      return Images.icCheckYesOnboardSetting.image
    case .enableNotification:
      return Images.icCheckOn.image
    }
  }

  var unselectedCheckImage: UIImage {
    switch self {
    case .confirmRemoveProfile:
      return Images.icCheckNotOnboardSetting.image
    case .comfirmFeedback:
      return Images.icCheckNotOnboardSetting.image
    case .enableNotification:
      return Images.icCheckOff.image
    }
  }


}

extension Button.Filter: ButtonCommonProtocol {
  var activeBackgroundColor: UIColor? { return Colors.blueL2.color }

  var disabledBackgroundColor: UIColor? { return Colors.blue.color }

  var activeTitleColor: UIColor? { return Colors.g6.color }

  var disabledTitleColor: UIColor? { return Colors.white.color }

  var title: String { return "필터" }
}
