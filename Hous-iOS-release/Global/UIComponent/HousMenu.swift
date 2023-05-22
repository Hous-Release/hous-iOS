//
//  HousMenu.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/14.
//

import UIKit

final class HousMenu: UIView {

  private let editButton = UIButton().then {
    $0.setTitleColor(Colors.blue.color, for: .normal)
    $0.setTitle(StringLiterals.ButtonTitle.Rule.edit, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }

  private let guideButton = UIButton().then {
    $0.setTitle(StringLiterals.ButtonTitle.Rule.guide, for: .normal)
    $0.setTitleColor(Colors.g6.color, for: .normal)
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }

  private let graySeperatorLine = UIView().then {
    $0.backgroundColor = Colors.g6.color
  }

  private lazy var stackView = UIStackView(arrangedSubviews: [
    editButton,
    graySeperatorLine,
    guideButton
  ]).then {
    $0.distribution = .equalSpacing
    $0.alignment = .leading
    $0.axis = .vertical
    $0.spacing = 8
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle() {
    self.layer.borderWidth = 1
    self.makeShadow(color: .black, opacity: 0.1, offset: CGSize(width: 0, height: 0), radius: 8)
    self.backgroundColor = Colors.white.color
    self.layer.borderColor = Colors.white.color.cgColor
    self.layer.cornerRadius = 8
  }

  private func setLayout() {
    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(14)
    }

    graySeperatorLine.snp.makeConstraints { make in
      make.height.equalTo(1)
    }
  }

}

extension HousMenu {

  func addEditButtonAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ButtonClosure) {
    editButton.addButtonAction(closure)
  }

  func addGuideButtonAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping ButtonClosure) {
    guideButton.addButtonAction(closure)
  }

}
