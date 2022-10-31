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
  func backButtonDidTappedWithoutPopUp()
}

class NavBarWithBackButtonView: UIView {

  lazy var backButton: UIButton = {
    var button = UIButton()
    button.setImage(Images.icBack.image, for: .normal)
    button.addTarget(self, action: #selector(backButtonDidTapped), for: .touchUpInside)
    return button
  }()
  
  weak var delegate: NavBarWithBackButtonViewDelegate?

  private var titleLabel: UILabel = {
    var label = UILabel()
    label.textColor = Colors.black.color
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    label.textAlignment = .center
    return label
  }()

  lazy var rightButton: UIButton = {
    var button = UIButton()
    button.setTitleColor(Colors.blue.color, for: .normal)
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    button.titleLabel?.textAlignment = .center
    return button
  }()

  var title: String
  var rightButtonText: String
  
  //TODO: rightButtonText 설정 setter 메서드 따로 빼기
  init(title: String, rightButtonText: String = "") {
    self.title = title
    self.rightButtonText = rightButtonText
    super.init(frame: .zero)
    
    titleLabel.text = title
    //TODO: 이렇게 하면 이미지만 있는 경우에 쓸 수 없음
//    rightButtonText == "" ? (self.rightButton.isHidden = true) : (self.rightButton.isHidden = false)
    rightButton.setTitle(rightButtonText, for: .normal)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setRightButtonImage(image: UIImage) {
    rightButton.setImage(image, for: .normal)
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
      make.size.greaterThanOrEqualTo(44)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(32)
    }
  }
  
  func updateRightButtonSnapKit() {
    rightButton.snp.remakeConstraints { make in
      make.size.greaterThanOrEqualTo(44)
      make.trailing.equalToSuperview().inset(4)
      make.centerY.equalTo(titleLabel)
    }
  }
}

extension NavBarWithBackButtonView {
  @objc private func backButtonDidTapped() {
    self.delegate?.backButtonDidTapped()
  }
}

