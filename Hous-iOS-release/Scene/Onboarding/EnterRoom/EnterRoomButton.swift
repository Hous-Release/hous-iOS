//
//  EnterRoomButton.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/25.
//

import UIKit

import SnapKit
import Then

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

  var titleLabel: String {
    switch self {
    case .new:
      return "방 만들기"
    case .exist:
      return "초대코드 입력하기"
    }
  }

  var subTitleLabel: String {
    switch self {
    case .new:
      return "가장 먼저 방을 만들어\n호미들을 초대해보세요!"
    case .exist:
      return "초대코드를 입력해\n방에 입장하세요!"
    }
  }
}

class EnterRoomButton: UIView {

  // 1. 밑에 두 변수 공통으로 묶기

  var titleLabel = UILabel().then {
    $0.text = "메롱"
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.textColor = Colors.white.color
    $0.numberOfLines = 2
    $0.lineBreakMode = .byWordWrapping
    $0.lineBreakStrategy = .hangulWordPriority
    $0.textAlignment = .left
  }

  var subTitleLabel = UILabel().then {
    $0.text = "메롱"
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.textColor = Colors.white.color
    $0.numberOfLines = 2
    $0.lineBreakMode = .byWordWrapping
    $0.lineBreakStrategy = .hangulWordPriority
    $0.textAlignment = .left
  }


  // 2. ui요소들 레이아웃 잡기
  
  init(roomType: EnterRoomType) {
    super.init(frame: .zero)
    setup()
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {


  }

  private func setup() {

  }
}
