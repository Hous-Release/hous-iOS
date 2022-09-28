//
//  EnterRoomType.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/28.
//

import UIKit

enum EnterRoomType {
  case new
  case exist

  var color: UIColor {
    switch self {
    case .new:
      return Colors.yellow.color
    case .exist:
      return Colors.red.color
    }
  }

  var titleText: String {
    switch self {
    case .new:
      return "방 만들기"
    case .exist:
      return "초대코드 입력하기"
    }
  }

  var subTitleText: String {
    switch self {
    case .new:
      return "가장 먼저 방을 만들어\n호미들을 초대해보세요!"
    case .exist:
      return "초대코드를 입력해\n방에 입장하세요!"
    }
  }

  var textFieldTitleText: String {
    switch self {
    case .new:
      return "방 만들기"
    case .exist:
      return "방 초대코드 입력하기"
    }
  }

  var textFieldSubTitleText: String {
    switch self {
    case .new:
      return "멤버들이 확인할 수 있도록 방 이름을 설정해주세요."
    case .exist:
      return "초대코드를 입력해야 방에 들어갈 수 있어요."
    }
  }

  var textFieldPlaceholderText: String {
    switch self {
    case .new:
      return "방 이름 설정"
    case .exist:
      return "방 코드 설정"
    }
  }

  var textFieldViewButtonText: String {
    switch self {
    case .new:
      return "방 만들기"
    case .exist:
      return "방 참여하기"
    }
  }
}
