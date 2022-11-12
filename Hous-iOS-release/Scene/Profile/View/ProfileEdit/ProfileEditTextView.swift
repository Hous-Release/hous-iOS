//
//  ProfileEditTextView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/12.
//

import UIKit
import SnapKit
import Then

final class ProfileEditTextViewObject: UIStackView {
  
  private let underlineLayer = CALayer()
  private let animatedUnderlineLayer = CALayer()
  let placeHolderString = "자기소개"
  var isEmptyState = true
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  private let underlineView = UIView().then {
    $0.layer.borderWidth = 2
    $0.layer.borderColor = Colors.g3.color.cgColor
  }
  
  let textView = ProfileEditTextView().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    $0.textColor = Colors.black.color
    $0.returnKeyType = .done
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    render()
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  private func setup() {
    self.axis = .vertical
    self.alignment = .fill
    self.distribution = .fill
    self.spacing = 0
  }
  
  private func render() {
    self.addArrangedSubviews(textView, underlineView)
    underlineView.snp.makeConstraints { make in
      make.height.equalTo(2)
    }
    
    textView.snp.makeConstraints { make in
      make.height.equalTo(30)
    }
    
    
    var frame = underlineView.bounds
    frame.size.height = 2
  }
}

extension ProfileEditTextViewObject {
  func textViewSelected() {
    if isEmptyState {
      textView.text = ""
      textView.textColor = Colors.black.color
    }
    
    var frame = underlineView.bounds
    frame.size.height = 2
    

    self.underlineLayer.frame = frame
    self.underlineLayer.backgroundColor = Colors.g3.color.cgColor
    self.underlineView.layer.addSublayer(underlineLayer)
    
    self.underlineView.layer.borderWidth = 0



    self.animatedUnderlineLayer.frame = frame
    self.animatedUnderlineLayer.backgroundColor = Colors.blue.color.cgColor
    underlineView.layer.addSublayer(animatedUnderlineLayer)
    
    let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
    animation.timingFunction = CAMediaTimingFunction(controlPoints: 0, -0.7, 0, 1.01)
    animation.values = [0, 1]
    animation.duration = 0.8
    animation.keyTimes = [0, 0.8]
    animatedUnderlineLayer.add(animation, forKey: "Selected")
  }
  
  func textViewUnselected() {
    if textView.text.isEmpty {
      textView.text = placeHolderString
      textView.textColor = Colors.g5.color
      
      isEmptyState = true
    }
    
    self.underlineLayer.removeFromSuperlayer()
    self.animatedUnderlineLayer.removeFromSuperlayer()
    self.underlineView.layer.borderWidth = 2
  }
  
  func textViewResize() {
    let initialSize = CGSize(width: Size.screenWidth - 48, height: 30)
    let estimateSize = self.textView.sizeThatFits(initialSize)
    self.textView.constraints.forEach { (constraint) in
      if constraint.firstAttribute == .height {
        constraint.constant = estimateSize.height
      }
    }
  }
  
  func textEmptyControl() {
    if textView.text.isEmpty {
      isEmptyState = true
    } else {
      isEmptyState = false
    }
  }
}

class ProfileEditTextView: UITextView {
  
  let underlineView = UIView().then {
    $0.backgroundColor = Colors.g3.color
  }
  
  let animatedUnderlineView = UIView().then {
    $0.backgroundColor = Colors.blue.color
  }
  
  private let invalidMessageLabel = UILabel().then {
    $0.textColor = Colors.red.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    self.textContainerInset = UIEdgeInsets(top: 0, left: 7, bottom: 10, right: 7)
    self.backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ProfileEditTextView {
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
