//
//  FilledHousTextField.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/10.
//

import UIKit

import AssetKit

final class FilledHousTextField: UITextField {

  private let maxCount: Int

  private let baseRightView = UIView()

  private let textCountLabel = HousLabel(
    text: "0/20",
    font: .EN2,
    textColor: Colors.g5.color
  )

  init(maxCount: Int) {
    self.maxCount = maxCount
    super.init(frame: .zero)
    setLayout()
    setStyle()
    registerNotification()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func setLayout() {
    self.snp.makeConstraints { make in
      make.height.equalTo(ScreenUtils.getHeight(46))
    }

    baseRightView.addSubView(textCountLabel)
    textCountLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(12)
      make.leading.equalToSuperview()
    }
  }

  private func setStyle() {
    self.addLeftPadding(16)
    self.rightViewMode = .always
    self.rightView = baseRightView
    self.backgroundColor = Colors.blueL2.color
    self.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    self.layer.cornerRadius = 8
    self.layer.masksToBounds = true
  }
}

private extension FilledHousTextField {

  func registerNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(change),
      name: .change, object: self
    )
  }

  @objc
  func change() {
    guard let text = self.text else { return }
    textCountLabel.text = "\(text.count)/\(maxCount)"
    if text.count <= maxCount {
      textCountLabel.textColor = Colors.g5.color
      self.backgroundColor = Colors.blueL2.color
      return
    }
    self.backgroundColor = Colors.g1.color
    textCountLabel.textColor = Colors.red.color
  }
}
