//
//  EnterRoomButton.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/25.
//

import UIKit

import SnapKit
import Then

class EnterRoomButtonView: UIView {

  var buttonType: EnterRoomType = .new {
    didSet {
      backgroundColor = buttonType.color
      titleLabel.text = buttonType.titleText
      subTitleLabel.text = buttonType.subTitleText
      imageView.image = Images.profileGreen.image
    }
  }

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
    buttonType = roomType
    makeRounded(cornerRadius: 10)
  }
}

extension EnterRoomButtonView {

  func animateClick(completion: @escaping () -> Void) {

    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.15) {
        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
      } completion: { _ in
        UIView.animate(withDuration: 0.15) {
          self.transform = CGAffineTransform.identity
        } completion: { _ in completion() }
      }
    }
  }
}
