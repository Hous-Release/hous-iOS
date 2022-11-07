//
//  ProfileEditTextField.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/08.
//

import UIKit

class ProfileEditTextField: UITextField {

  let underlineLayer = CALayer()
  let animatedUnderlineLayer = CALayer()

  var birthdayPublicButton = UIButton().then {
    $0.setImage(Images.icShow.image, for: .normal)
    $0.setImage(Images.icShowOn.image, for: .selected)
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
    
    animatedUnderlineLayer.frame = frame
    animatedUnderlineLayer.backgroundColor = Colors.blue.color.cgColor
  }
}

extension ProfileEditTextField {
  func textFieldSelected() {
    self.layer.addSublayer(animatedUnderlineLayer)
    
    let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
    animation.timingFunction = CAMediaTimingFunction(controlPoints: 0, -0.7, 0, 1.01)
    animation.values = [0, 1]
    animation.duration = 0.8
    animation.keyTimes = [0, 0.8]
    animatedUnderlineLayer.add(animation, forKey: "Selected")
  }
  
  func textFieldUnselected() {
    let animatedUnderLineLayer = self.animatedUnderlineLayer
    animatedUnderLineLayer.removeFromSuperlayer()
  }
}
