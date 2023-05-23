//
//  ConfirmRemoveProfileView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit
import HousUIComponent

final class ConfirmRemoveProfileView: UIView {

  enum Size {
    static let guideLabel: Double = 13
  }

  let navigationBarView = NavBarWithBackButtonView(
    title: "회원 탈퇴",
    rightButtonText: "",
    isSeparatorLineHidden: false)

  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fillProportionally
    $0.spacing = 24
  }

  let titleLabel = UILabel().then {
    $0.text = "정말 탈퇴하시겠어요?"
    $0.textColor = Colors.g7.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.textAlignment = .center
  }

  let imageView = UIImageView().then {
    $0.image = Images.resign.image
    $0.makeRounded(cornerRadius: 8)
    $0.clipsToBounds = true
  }

  let guideLabel = UILabel().then {

    let style = NSMutableParagraphStyle()
    let lineheight = Size.guideLabel * 1.84
    style.minimumLineHeight = lineheight
    style.maximumLineHeight = lineheight

    $0.attributedText = NSAttributedString(
      string: "회원을 탈퇴하면 탈퇴 신청 즉시\n회원의 개인정보는 삭제되며 복구할 수 없습니다.",
      attributes: [
        .paragraphStyle: style,
        .baselineOffset: (lineheight - Size.guideLabel) / 4
      ])
    $0.textColor = Colors.g4.color
    $0.numberOfLines = 2
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: Size.guideLabel)
    $0.textAlignment = .center
  }

  let confirmButton = CheckButton(.confirmRemoveProfile).then {
    $0.isSelected = false
  }

  var removeProfileButton = OnboardingButton(.leaveProfile).then {
    $0.isEnabled = false
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI() {

    addSubViews([navigationBarView, stackView, removeProfileButton])
    stackView.addArrangedSubviews(titleLabel, imageView, guideLabel, confirmButton)

    navigationBarView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(NavigationBar.height)
    }

    stackView.snp.makeConstraints { make in
      make.trailing.leading.equalToSuperview().inset(28)
      make.center.equalToSuperview()
    }

    removeProfileButton.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(86)
    }
  }
}
