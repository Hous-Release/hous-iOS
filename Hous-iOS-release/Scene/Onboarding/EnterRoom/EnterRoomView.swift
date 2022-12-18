//
//  EnterRoomView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/25.
//

import UIKit

import SnapKit
import Then

class EnterRoomView: UIView {

  enum Size {
    static let navigationBarHeight = 64
  }

  let navigationBarView = NavBarWithBackButtonView(title: "", rightButtonText: "").then {
    $0.backButton.isHidden = true
    $0.rightButton.configuration?.image = Images.icSettingGrey.image
  }

  let contentView = UIView()

  let guideTitleLabel = UILabel().then {
    $0.text = "이제 하우스를 입장해볼까요?"
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.textColor = Colors.black.color
  }

  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 28
    $0.distribution = .fillEqually
    $0.alignment = .fill
  }

  let newRoomView = EnterRoomButtonView(roomType: .new)
  let existRoomView = EnterRoomButtonView(roomType: .exist)

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    backgroundColor = Colors.white.color
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    addSubViews([navigationBarView, contentView])
    contentView.addSubViews([guideTitleLabel, stackView])
    stackView.addArrangedSubviews(newRoomView, existRoomView)

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(Size.navigationBarHeight)
    }

    contentView.snp.makeConstraints { make in
      make.top.equalTo(navigationBarView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    guideTitleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
    }

    stackView.snp.makeConstraints { make in
      make.top.equalTo(guideTitleLabel.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(24)
      make.centerY.equalToSuperview()
    }
  }
}
