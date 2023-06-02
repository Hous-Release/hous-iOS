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

public enum Button {

  public enum Onboarding: ButtonCommonProtocol {
    case next, createRoom, enterRoom, start, toStart, leaveProfile

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

}

extension Button {

  public enum Basic: ButtonCommonProtocol {
    case kakao, apple, save, retry

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

}

extension Button {

  public enum Check: ButtonCommonProtocol {
    case confirmRemoveProfile, comfirmFeedback

    var activeBackgroundColor: UIColor? { return nil }

    var disabledBackgroundColor: UIColor? { return nil }

    var activeTitleColor: UIColor? {
      switch self {
      case .confirmRemoveProfile:
        return Colors.red.color
      case .comfirmFeedback:
        return Colors.blue.color
      }
    }

    var disabledTitleColor: UIColor? {
      switch self {
      case .confirmRemoveProfile:
        return Colors.redB1.color
      case .comfirmFeedback:
        return Colors.blueL1.color
      }
    }

    var title: String {
      switch self {
      case .confirmRemoveProfile:
        return "탈퇴하겠습니다"
      case .comfirmFeedback:
        return "동의합니다."
      }
    }
  }
}
