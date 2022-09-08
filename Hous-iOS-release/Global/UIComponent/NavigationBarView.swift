//
//  NavigationBarView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit
import SnapKit

class NavBarWithBackButtonView: UIView {

  var backButton: UIButton = {
    var button = UIButton()
    button.setImage(Images.icBack.image, for: .normal)
    return button
  }()

  private var titleLabel: UILabel = {
    var label = UILabel()
    label.textColor = Colors.black.color
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    label.textAlignment = .center
    return label
  }()

  var rightButton: UIButton = {
    var button = UIButton()
    button.titleLabel?.textColor = Colors.blue.color
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    button.titleLabel?.textAlignment = .center
    return button
  }()

  var title: String
  var rightButtonText: String

  init(title: String, rightButtonText: String = "") {
    self.title = title
    self.rightButtonText = rightButtonText

    super.init(frame: .zero)
    
    titleLabel.text = title
    rightButtonText == "" ? self.rightButton.isHidden = true : nil
    rightButton.titleLabel?.text = rightButtonText

    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {

    backgroundColor = Colors.white.color

    addSubViews([backButton, titleLabel, rightButton])

    backButton.snp.makeConstraints { make in
      make.size.equalTo(44)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(4)
    }

    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    rightButton.snp.makeConstraints { make in
      make.size.equalTo(44)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(12)
    }
  }
}
