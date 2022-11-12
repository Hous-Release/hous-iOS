//
//  ProfileEditTextField.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/08.
//

import UIKit
import Then

class ProfileEditTextField: UITextField {
  
  let underlineLayer = CALayer()
  let animatedunderlineLayer = CALayer()
  private let invalidMessageLabel = UILabel().then {
    $0.textColor = Colors.red.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }
  
  var birthdayPublicButton = UIButton().then {
    $0.setImage(Images.icShow.image, for: .normal)
    $0.setImage(Images.icShowOn.image, for: .selected)
    $0.adjustsImageWhenHighlighted = false
  }
  
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupUnderlineLayer()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.addSublayer(underlineLayer)
    self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
    self.leftViewMode = .always
    self.rightView = birthdayPublicButton
    self.rightViewMode = .always
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUnderlineLayer() {
    var frame = self.bounds
    frame.origin.y = frame.size.height + 8
    frame.size.height = 2
    
    underlineLayer.frame = frame
    underlineLayer.backgroundColor = Colors.g3.color.cgColor
    
    animatedunderlineLayer.frame = frame
    animatedunderlineLayer.backgroundColor = Colors.blue.color.cgColor
  }
}

extension ProfileEditTextField {
  func textFieldSelected() {
    self.layer.addSublayer(animatedunderlineLayer)
    
    let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
    animation.timingFunction = CAMediaTimingFunction(controlPoints: 0, -0.7, 0, 1.01)
    animation.values = [0, 1]
    animation.duration = 0.8
    animation.keyTimes = [0, 0.8]
    animatedunderlineLayer.add(animation, forKey: "Selected")
  }
  
  func textFieldUnselected() {
    let animatedunderlineLayer = self.animatedunderlineLayer
    animatedunderlineLayer.removeFromSuperlayer()
  }
  
  func invalidDataOn(attributeName: String, count: Int) {
    self.addSubview(invalidMessageLabel)
    
    invalidMessageLabel.snp.makeConstraints { make in
      make.leading.equalTo(self.snp.leading).offset(12)
      make.top.equalTo(self.snp.bottom).offset(16)
    }
    
    invalidMessageLabel.text = "\(attributeName) \(count)자 이내로 입력해주세요!"
    
  }
  
  func invalidDataOff() {
    invalidMessageLabel.removeFromSuperview()
  }
  
}

