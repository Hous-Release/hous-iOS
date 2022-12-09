//
//  HousTextField.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/17.
//

import AssetKit
import UIKit


final class HousTextField: UITextField {

  private let defaultUnderlineLayer = CALayer()
  private let selectedUnderlineLayer = CALayer()

  private lazy var maxCountLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.Montserrat.regular.font(size: 12)
    label.textColor = Colors.g5.color
    return label
  }()

  private let exceedLabel: UILabel = {
    let label = UILabel()
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    label.textColor = Colors.red.color
    label.isHidden = true
    return label
  }()

  private let useMaxCount: Bool
  private let maxCount: Int?
  private let exceedString: String?
  public var isValidate: Bool

  init(
    _ placeHolder: String? = nil,
    _ text: String? = nil,
    useMaxCount: Bool = false,
    maxCount: Int? = nil,
    exceedString: String? = nil
  ) {
    self.isValidate = !useMaxCount
    self.useMaxCount = useMaxCount
    self.maxCount = maxCount
    self.exceedString = exceedString
    super.init(frame: .zero)
    self.layer.addSublayer(defaultUnderlineLayer)
    self.placeholder = placeHolder
    self.text = text
    self.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    setupViews()
    registerForNotifications()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setupPosition()
    setupLayerPosition()
  }


  private func setupViews() {
    selectedUnderlineLayer.backgroundColor = Colors.blue.color.cgColor
    defaultUnderlineLayer.backgroundColor = Colors.g4.color.cgColor

    if useMaxCount {
      self.addSubView(maxCountLabel)
      self.addSubView(exceedLabel)
    }
    guard
      let maxCount = maxCount
    else {
      return
    }
    maxCountLabel.text = "\(self.text?.count ?? 0)/\(maxCount)"
    exceedLabel.text = exceedString
  }

  private func setupPosition() {
    guard useMaxCount else {
      return
    }

    var frame = self.bounds

    frame.origin.y = bounds.size.height + 16
    frame.origin.x = bounds.size.width - 24
    frame.size = CGSize(width: 30, height: 18)

    var frame2 = self.bounds
    frame2.origin.y = bounds.size.height + 16
    frame2.size = CGSize(width: bounds.size.width - 30, height: 18)

    maxCountLabel.frame = frame
    exceedLabel.frame = frame2

  }

  private func setupLayerPosition() {
    var frame = self.bounds
    frame.origin.y = frame.size.height + 8
    frame.size.height = 2

    defaultUnderlineLayer.frame = frame
    selectedUnderlineLayer.frame = frame
  }


  @objc
  func change() {
    guard
      let maxCount = maxCount,
      let text = self.text
    else {
      return
    }

    maxCountLabel.text = "\(text.count)/\(maxCount)"
    isExceed(text.count)
    textFieldIsEmpty(text.count)
  }

  private func textFieldIsEmpty(_ count: Int) {

    if count == 0 {
      selectedUnderlineLayer.removeFromSuperlayer()
      isValidate = false
    }
    else {
      self.layer.addSublayer(selectedUnderlineLayer)
      isValidate = true
    }
  }

  private func isExceed(_ count: Int) {
    guard let maxCount = maxCount else {
      return
    }
    guard count != 0 else {
      return
    }

    if count > maxCount {
      maxCountLabel.textColor = Colors.red.color
      exceedLabel.isHidden = false
      isValidate = false
    } else {
      maxCountLabel.textColor = Colors.g5.color
      exceedLabel.isHidden = true
      isValidate = true
    }

  }

  // MARK: - 얼라인 때문에 사용 안함
  @objc
  private func beginEdit() {

    guard let text = text else { return }

    if useMaxCount && ((maxCount ?? 0) < text.count) {
      return
    }

    self.layer.addSublayer(selectedUnderlineLayer)

    let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
    animation.timingFunction = CAMediaTimingFunction(controlPoints: 0, -0.7, 0, 1.01)
    animation.values = [0, 1]
    animation.duration = 0.8
    animation.keyTimes = [0, 0.8]
    selectedUnderlineLayer.add(animation, forKey: "Selected")
  }

  // MARK: - 얼라인 때문에 사용 안함
  @objc
  private func endEdit() {
    guard let text = text else { return }

    if useMaxCount && (maxCount ?? 0)  < text.count  || text.count == 0 {
      isExceed(text.count)
      return
    }
//    selectedUnderlineLayer.removeFromSuperlayer()
  }
}

extension HousTextField {
  private func registerForNotifications() {

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(change),
      name: .change,
      object: self
    )
    // MARK: - 얼라인 때문에 사용 안함

//    NotificationCenter.default.addObserver(
//      self,
//      selector: #selector(beginEdit),
//      name: .beginEdit,
//      object: self
//    )

//    NotificationCenter.default.addObserver(
//      self,
//      selector: #selector(endEdit),
//      name: .endEdit,
//      object: self
//    )

  }

  

}

extension HousTextField {
  func changeSelectedUnderlineLayerBackgrounColor(color: CGColor?) {
    selectedUnderlineLayer.backgroundColor = color
  }
}


fileprivate extension NSNotification.Name {
  static let change = Notification.Name("UITextFieldTextDidChangeNotification")
  static let beginEdit = Notification.Name("UITextFieldTextDidBeginEditingNotification")
  static let endEdit = Notification.Name("UITextFieldTextDidEndEditingNotification")
}
