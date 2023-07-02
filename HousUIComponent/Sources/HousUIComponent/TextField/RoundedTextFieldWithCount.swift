//
//  RoundedTextFieldWithCount.swift
//  
//
//  Created by 김호세 on 2023/07/02.
//

import AssetKit
import UIKit

public final class RoundedTextFieldWithCount: UITextField {

  private struct Constants {
    static let horizontal = 16

  }

  private lazy var maxCountLabel: HousLabel = {
    let label = HousLabel(text: nil, font: .EN2, textColor: Colors.g5.color)
    return label
  }()

  // MARK: - Variable & Properties

  public override var text: String? {
    didSet {
      maxCountLabel.text = "\(self.text?.count ?? 0)/\(maxCount)"
    }
  }

  public var isValidate: Bool {
    get {
      (text?.count ?? 0) > 0 && (text?.count ?? 0) <= maxCount
    }
  }

  private let maxCount: Int

  public init(
    maxCount: Int
  ) {
    self.maxCount = maxCount
    super.init(frame: .zero)
    setupViews()
    setupStyles()
    registerForNotifications()
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private func setupStyles() {
    self.font = HousFont.B2.font
    self.textColor = Colors.black.color
    self.makeRounded(cornerRadius: 8)
    self.backgroundColor = Colors.blueL2.color
  }

  private func setupViews() {
    self.addSubview(maxCountLabel)
    self.addLeftPadding(CGFloat(Constants.horizontal))
    maxCountLabel.text = "\(text?.count ?? 0)/\(maxCount)"

    maxCountLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(Constants.horizontal)
    }
  }

}
extension RoundedTextFieldWithCount {
  @objc
  func change() {
    maxCountLabel.text = "\(self.text?.count ?? 0)/\(maxCount)"
    maxCountLabel.textColor =  isValidate ?  Colors.g5.color : Colors.red.color
  }

  private func registerForNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(change),
      name: .change,
      object: self
    )
  }
}
