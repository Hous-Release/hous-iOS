//
//  QuitPopViewController.swift
//  
//
//  Created by 김호세 on 2022/10/09.
//

import UIKit
import SnapKit
import Then

protocol QuitPopViewControllerDelegate: AnyObject {
  func cancelButtonDidTapped()
}

class QuitPopViewController: UIViewController {

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let popUpWidth = Size.screenWidth * (295/375)
    static let popUpHeight = Size.popUpWidth * (185/295)
  }

  weak var delegate: QuitPopViewControllerDelegate?

  private let popUpView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 8
  }

  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.textAlignment = .center
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    $0.dynamicFont(fontSize: 18, weight: .bold)
  }

  private let subtitleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.lineBreakMode = .byWordWrapping
    $0.lineBreakStrategy = .hangulWordPriority
    $0.textAlignment = .center
    $0.textColor = Colors.g5.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.dynamicFont(fontSize: 12, weight: .medium)
  }

//  private lazy var popUpCloseButton = UIButton().then {
//    $0.setImage(R.Image.popupCloseHome, for: .normal)
//    $0.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
//  }

  private lazy var continueButton = UIButton().then {
    var config = UIButton.Configuration.filled()
    var container = AttributeContainer()
    container.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)

    config.attributedTitle = AttributedString("나가기", attributes: container)
    config.baseBackgroundColor = Colors.g3.color
    config.baseForegroundColor = Colors.g6.color

    $0.configuration = config
    $0.layer.cornerRadius = 8
    $0.layer.masksToBounds = true
    $0.addTarget(self, action: #selector(continueButtonDidTapped), for: .touchUpInside)
  }


  private lazy var cancelButton = UIButton().then {
    var config = UIButton.Configuration.filled()
    var container = AttributeContainer()
    container.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)

    config.attributedTitle = AttributedString("나가기", attributes: container)
    config.baseBackgroundColor = Colors.red.color
    config.baseForegroundColor = .white

    $0.configuration = config
    $0.layer.cornerRadius = 8
    $0.layer.masksToBounds = true
    $0.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
  }

  private lazy var buttonStackView = UIStackView(arrangedSubviews: [continueButton, cancelButton]).then {
    $0.axis = .horizontal
    $0.spacing = 11
  }

  //MARK: Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .black.withAlphaComponent(0.4)
    render()
  }

  //MARK: Custom Methods

  private func render() {
    self.view.addSubview(popUpView)
    popUpView.addSubViews([titleLabel, subtitleLabel, buttonStackView])

    popUpView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(Size.popUpWidth)
      make.height.equalTo(Size.popUpHeight)
    }

    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(popUpView).inset(32)
      make.centerX.equalTo(popUpView)
    }

    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.centerX.equalTo(titleLabel)
    }

    buttonStackView.snp.makeConstraints { make in
      make.top.equalTo(subtitleLabel.snp.bottom).offset(18)
      make.leading.trailing.equalTo(popUpView).inset(18)
      make.bottom.equalTo(popUpView).inset(16)
      make.height.equalTo(40)
    }
  }

  func configPopupTexts(titleLabelText: String, subtitleLabelText: String, continueButtonText: String, cancelButtonText: String) {
    self.titleLabel.text = titleLabelText
    self.subtitleLabel.text = subtitleLabelText

    let continueButtonConfig = makeButtonConfig(text: continueButtonText, isQuitButton: false)
    let cancelButtonConfig = makeButtonConfig(text: cancelButtonText, isQuitButton: true)

    self.continueButton.configuration = continueButtonConfig
    self.cancelButton.configuration = cancelButtonConfig
  }

  private func makeButtonConfig(text: String, isQuitButton: Bool) -> UIButton.Configuration {
    var config = UIButton.Configuration.filled()

    var container = AttributeContainer()
    container.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    config.attributedTitle = AttributedString(text, attributes: container)
    config.baseBackgroundColor = isQuitButton ? Colors.red.color : Colors.g3.color
    config.baseForegroundColor = isQuitButton ? .white : Colors.g6.color

    return config
  }
}


//MARK: Objective-C methods

extension QuitPopViewController {

  @objc private func cancelButtonDidTapped() {
    self.dismiss(animated: false) { [weak self]  in
      guard let self = self else { return }
      self.delegate?.cancelButtonDidTapped()
    }
  }

  @objc private func continueButtonDidTapped() {
    self.dismiss(animated: true)
  }
}
