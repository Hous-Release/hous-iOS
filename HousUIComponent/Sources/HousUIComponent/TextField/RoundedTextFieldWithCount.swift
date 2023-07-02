//
//  RoundedTextFieldWithCount.swift
//  
//
//  Created by 김호세 on 2023/07/02.
//

import AssetKit
import UIKit

public final class RoundedTextFieldWithCount: UITextField {

  private lazy var maxCountLabel: HousLabel = {
    let label = HousLabel(text: nil, font: .EN2, textColor: Colors.g5.color)
    return label
  }()

  // MARK: - Variable & Properties

  private let maxCount: Int
  public var isValidate: Bool {
    get {
      (text?.count ?? 0) > 0 && (text?.count ?? 0) <= maxCount
    }
  }

  public init(
    maxCount: Int
  ) {
    self.maxCount = maxCount
    super.init(frame: .zero)
    setupViews()
    setupStyles()
//    registerForNotifications()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
  }

  private func setupStyles() {
    self.font = HousFont.B2.font
    self.textColor = Colors.black.color
  }

  private func setupViews() {

//    if useMaxCount {
//      self.addSubView(maxCountLabel)
//      self.addSubView(exceedLabel)
//    }
//    guard
//      let maxCount = maxCount
//    else {
//      return
//    }
//    if let text = self.text {
//      if text.count > 0 {
//        self.layer.addSublayer(selectedUnderlineLayer)
//        maxCountLabel.text = "\(text.count)/\(maxCount)"
//      }
//    } else {
//      maxCountLabel.text = "0/\(maxCount)"
//    }
  }


//  @objc
//  func change() {
//    guard
//      let maxCount = maxCount,
//      let text = self.text
//    else {
//      return
//    }
//
//    maxCountLabel.text = "\(text.count)/\(maxCount)"
//    isExceed(text.count)
//    textFieldIsEmpty(text.count)
//  }

//  private func textFieldIsEmpty(_ count: Int) {
//
//    if count == 0 {
//      isValidate = false
//    } else {
//      isValidate = true
//    }
//  }
//
//  private func isExceed(_ count: Int) {
//    guard let maxCount = maxCount else {
//      return
//    }
//    guard count != 0 else {
//      return
//    }
//
//    if count > maxCount {
//      maxCountLabel.textColor = Colors.red.color
//      isValidate = false
//    } else {
//      maxCountLabel.textColor = Colors.g5.color
//      isValidate = true
//    }
//
//  }

}

//extension RoundedTextFieldWithCount {
//  private func registerForNotifications() {
//
//    NotificationCenter.default.addObserver(
//      self,
//      selector: #selector(change),
//      name: .change,
//      object: self
//    )
//  }
//
//}
//
//extension RoundedTextFieldWithCount {
//
//}
//
//// 외부 노출
//public extension RoundedTextFieldWithCount {
//  func textFieldChange() {
//    self.change()
//  }
//}
