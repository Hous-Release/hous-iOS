//
//  ProfileTestCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/12.
//

import UIKit
import Kingfisher

protocol TestCollectionViewCellDelegate: AnyObject {
  func optionButtonDidTapped(_ sender: UIButton, _ tag: Int)
}


class TestCollectionViewCell: UICollectionViewCell {

  weak var delegate: TestCollectionViewCellDelegate?

  private let testTitleLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.bold.font(size: 20)
    $0.numberOfLines = 2
    $0.lineBreakStrategy = .hangulWordPriority
    $0.lineBreakMode = .byWordWrapping
    $0.textAlignment = .center
  }

  private let testImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }

  private lazy var optionButton1 = UIButton().then {
    $0.tag = 0
  }

  private lazy var optionButton2 = UIButton().then {
    $0.tag = 1
  }

  private lazy var optionButton3 = UIButton().then {
    $0.tag = 2
  }

  private lazy var buttonStackView = UIStackView(arrangedSubviews: [optionButton1, optionButton2, optionButton3]).then {
    $0.axis = .vertical
    $0.spacing = 16
    $0.distribution = .fillEqually
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setOptionButton(sender: UIButton, optionText: String) {
    var configuration = UIButton.Configuration.filled()
    configuration.automaticallyUpdateForSelection = false

    var container = AttributeContainer()
    container.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)

    let handler: UIButton.ConfigurationUpdateHandler = { button in
      switch button.state {
      case .selected:
        button.configuration?.baseBackgroundColor = Colors.redL1.color

      default:
        button.configuration?.baseBackgroundColor = Colors.g1.color
      }
    }

    configuration.attributedTitle = AttributedString(optionText, attributes: container)

    sender.layer.cornerRadius = 15
    sender.layer.masksToBounds = true

    sender.configuration = configuration
    sender.configurationUpdateHandler = handler
    sender.titleLabel?.textAlignment = .center

    sender.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
  }

  private func render() {
    self.addSubViews([testTitleLabel, testImageView, buttonStackView])

    testTitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.centerX.equalToSuperview()
    }

    testImageView.snp.makeConstraints { make in
      make.top.equalTo(testTitleLabel.snp.bottom).offset(18)
      make.centerX.equalTo(testTitleLabel)
      make.leading.trailing.equalToSuperview().inset(25)
      make.width.height.equalTo(325)
    }

    buttonStackView.snp.makeConstraints { make in
      make.top.equalTo(testImageView.snp.bottom).offset(30).multipliedBy(0.9)
      make.centerX.equalTo(testImageView)
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview().inset(21)
    }
  }

  func setTestData(_ data: ProfileTestCellItem) {
    testTitleLabel.text = data.testTitle
    // url -> image
    testImageView.kf.setImage(with: URL(string: data.testImg))

    let sequence = zip([optionButton1, optionButton2, optionButton3], data.testAnswers)

    for (button, data) in sequence {

      setOptionButton(sender: button, optionText: data.optionText)
      button.isSelected = data.isSelected
    }
  }

}

extension TestCollectionViewCell {
  @objc private func buttonPressed(_ sender: UIButton) {

    deselectButtons([optionButton1, optionButton2, optionButton3])
    sender.isSelected = true
    delegate?.optionButtonDidTapped(sender, sender.tag)
  }

  func deselectButtons(_ buttonList: [UIButton]) {
    buttonList.forEach {
      $0.isSelected = false
    }
  }
}
