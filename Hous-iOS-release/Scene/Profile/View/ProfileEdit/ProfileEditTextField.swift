//
//  ProfileEditTextField.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/08.
//

import UIKit
import Then

class ProfileEditTextField: UITextField {

  var isFloatingErrorMessage: Bool = false
  let underlineLayer = CALayer()
  let animatedunderlineLayer = CALayer()
  private let invalidMessageLabel = UILabel().then {
    $0.textColor = Colors.red.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }

  var birthdayPublicButton = UIButton(configuration: .plain()).then {
    $0.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 22, leading: 0, bottom: 0, trailing: 0)
    $0.configurationUpdateHandler = { btn in
      switch btn.state {
      case .normal:
        btn.configuration?.image = Images.icShow.image
      case .selected:
        btn.configuration?.baseBackgroundColor = .clear
        btn.configuration?.image = Images.icShowOn.image
      case .highlighted:
        btn.configuration?.image = btn.isSelected ? Images.icShowOn.image : Images.icShow.image
      default:
        break
      }
    }
  }

  override var intrinsicContentSize: CGSize {
    return isFloatingErrorMessage ? CGSize(
      width: UIView.noIntrinsicMetric, height: 70) : CGSize(width: UIView.noIntrinsicMetric, height: 59)
  }

  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return isFloatingErrorMessage ? bounds.inset(by: UIEdgeInsets(top: 12, left: 4, bottom: 0, right: 0))
    : bounds.inset(by: UIEdgeInsets(top: 24, left: 4, bottom: 0, right: 0))
  }

  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return isFloatingErrorMessage ? bounds.inset(by: UIEdgeInsets(top: 12, left: 4, bottom: 0, right: 0))
    : bounds.inset(by: UIEdgeInsets(top: 24, left: 4, bottom: 0, right: 0))
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setupUnderlineLayer()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.addSublayer(underlineLayer)
    self.rightView = birthdayPublicButton
    self.rightViewMode = .always
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupUnderlineLayer() {
    var frame = self.bounds
    frame.origin.y = self.isFloatingErrorMessage ? frame.size.height - 11 : frame.size.height
    frame.size.height = 2

    underlineLayer.frame = frame
    underlineLayer.backgroundColor = Colors.g3.color.cgColor

    animatedunderlineLayer.frame = frame
    animatedunderlineLayer.backgroundColor = Colors.blue.color.cgColor
  }
}

extension ProfileEditTextField {
  func textFieldFilled() {
    self.layer.addSublayer(animatedunderlineLayer)

    let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
    animation.timingFunction = CAMediaTimingFunction(controlPoints: 0, -0.7, 0, 1.01)
    animation.values = [0, 1]
    animation.duration = 0.8
    animation.keyTimes = [0, 0.8]
    //    animatedunderlineLayer.add(animation, forKey: "Selected")
  }

  func textFieldEmpty() {
    let animatedunderlineLayer = self.animatedunderlineLayer
    animatedunderlineLayer.removeFromSuperlayer()
  }

  func invalidDataOn(attributeName: String, count: Int) {
    self.addSubview(invalidMessageLabel)
    self.isFloatingErrorMessage = true

    invalidMessageLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(4)
      make.top.equalTo(self.snp.bottom)

    }

    invalidMessageLabel.text = "\(attributeName) \(count)자 이내로 입력해주세요!"

    self.reloadInputViews()

  }

  func invalidDataOff() {
    invalidMessageLabel.removeFromSuperview()
    self.isFloatingErrorMessage = false
    self.reloadInputViews()
  }

}
