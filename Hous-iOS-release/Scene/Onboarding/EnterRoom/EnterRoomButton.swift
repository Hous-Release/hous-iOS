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
}

class EnterRoomButtonView: UIView {

  var titleLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.textColor = Colors.white.color
    $0.textAlignment = .left
  }

  var subTitleLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.numberOfLines = 2
    $0.textColor = Colors.white.color
    $0.lineBreakMode = .byWordWrapping
    $0.lineBreakStrategy = .hangulWordPriority
    $0.textAlignment = .left
  }

  var imageView = UIImageView()

  init(roomType: EnterRoomType) {
    super.init(frame: .zero)
    setup(roomType)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    addSubViews([titleLabel, subTitleLabel, imageView])

    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.leading.equalToSuperview().offset(24)
    }

    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.equalTo(titleLabel.snp.leading)
    }

    imageView.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(24)
      make.leading.greaterThanOrEqualTo(subTitleLabel.snp.trailing).offset(16)
      make.width.equalTo(110)
      make.width.equalTo(imageView.snp.height)
      make.bottom.equalToSuperview().inset(20)
    }

    self.snp.makeConstraints { make in
      make.height.equalTo(200)
    }
  }

  private func setup(_ roomType: EnterRoomType) {
    backgroundColor = roomType.color
    titleLabel.text = roomType.titleText
    subTitleLabel.text = roomType.subTitleText
    makeRounded(cornerRadius: 10)
    imageView.image = Images.profileGreen.image
  }
}
