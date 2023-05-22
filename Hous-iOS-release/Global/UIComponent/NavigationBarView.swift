//
//  NavigationBarView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit
import SnapKit

protocol NavBarWithBackButtonViewDelegate: AnyObject {
  func backButtonDidTapped()
}

class NavBarWithBackButtonView: UIView {

  lazy var backButton = UIButton().then {
    $0.setImage(Images.icBack.image, for: .normal)
    $0.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
  }

  weak var delegate: NavBarWithBackButtonViewDelegate?

  private var titleLabel = UILabel().then {
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.textAlignment = .center
  }

  lazy var rightButton = UIButton().then {
    $0.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.setTitleColor(Colors.blue.color, for: .normal)
    $0.titleLabel?.textAlignment = .right
  }

  private let grayLineView = UIView().then {
    $0.backgroundColor = Colors.g1.color
  }

  var title: String = "" {
    didSet {
      titleLabel.text = title
    }
  }
  var rightButtonText: String = "" {
    didSet {
      rightButton.setTitle(rightButtonText, for: .normal)
      rightButton.setImage(nil, for: .normal)
    }
  }
  var rightButtonImage: UIImage? {
    didSet {
      rightButton.setTitle("", for: .normal)
      rightButton.setImage(rightButtonImage, for: .normal)
    }
  }

  init(title: String = "",
       rightButtonText: String = "",
       rightButtonImage: UIImage? = nil,
       isSeparatorLineHidden: Bool = true
  ) {
    super.init(frame: .zero)
    configUI(title, rightButtonText, rightButtonImage, isSeparatorLineHidden)
    render()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI(
    _ title: String,
    _ rightButtonText: String,
    _ rightButtonImage: UIImage?,
    _ isSeparatorLineHidden: Bool
  ) {
    titleLabel.text = title
    rightButton.setTitle(rightButtonText, for: .normal)
    rightButton.setImage(rightButtonImage, for: .normal)
    isSeparatorLineHidden ? (grayLineView.isHidden = true) : (grayLineView.isHidden = false)
  }

  private func render() {

    backgroundColor = Colors.white.color

    addSubViews([backButton, titleLabel, rightButton, grayLineView])

    backButton.snp.makeConstraints { make in
      make.size.equalTo(24)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(24)
    }

    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    rightButton.snp.makeConstraints { make in
      make.size.greaterThanOrEqualTo(24)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(24)
    }

    grayLineView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
  }

  func setTitleLabelTextColor(color: UIColor) {
    titleLabel.textColor = color
  }

  func setRightButtonTextColor(color: UIColor) {
    rightButton.setTitleColor(color, for: .normal)
  }

  func setBackButtonColor(color: UIColor) {
    backButton.tintColor = color
  }
}

extension NavBarWithBackButtonView {
  @objc private func backButtonDidTapped() {
    self.delegate?.backButtonDidTapped()
  }
}
