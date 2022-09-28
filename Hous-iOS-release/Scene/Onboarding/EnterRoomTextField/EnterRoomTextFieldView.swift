//
//  EnterRoomTextFieldView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/28.
//

import UIKit

import SnapKit
import Then

class EnterRoomTextFieldView: UIView {

  var navigationBar = NavBarWithBackButtonView(title: "")
  private var contentView = UIView()

  private let titleLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.textColor = Colors.black.color
  }

  private let subTitleLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
  }

  var textField = UnderlinedTextField().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g4.color
  }

  var errorLabel = UILabel().then {
    $0.text = "* 참여할 수 없는 코드예요."
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.red.color
  }

  var enterRoomButton = UIButton().then {
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.titleLabel?.textColor = Colors.white.color
    $0.setBackgroundColor(Colors.g4.color, for: .disabled)
    $0.setBackgroundColor(Colors.blue.color, for: .normal)
    $0.isEnabled = false
  }

  init(roomType: EnterRoomType) {
    super.init(frame: .zero)
    render()
    setup(roomType)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    addSubViews([navigationBar, contentView, enterRoomButton])
    contentView.addSubViews([titleLabel, subTitleLabel, textField, errorLabel])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(60)
    }

    contentView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.centerY.equalToSuperview().multipliedBy(0.65)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
    }
    subTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalToSuperview()
    }
    textField.snp.makeConstraints { make in
      make.top.equalTo(subTitleLabel.snp.bottom).offset(28)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(38)
    }
    errorLabel.snp.makeConstraints { make in
      make.top.equalTo(textField.snp.bottom).offset(12)
      make.leading.equalToSuperview()
    }

    enterRoomButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(86)
    }
  }

  private func setup(_ roomType: EnterRoomType) {
    titleLabel.text = roomType.textFieldTitleText
    subTitleLabel.text = roomType.textFieldSubTitleText
    textField.placeholder = roomType.textFieldPlaceholderText
    enterRoomButton.setTitle(roomType.textFieldViewButtonText, for: .normal)
  }

}
