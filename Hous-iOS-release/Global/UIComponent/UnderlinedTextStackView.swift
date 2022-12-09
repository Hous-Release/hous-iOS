//
//  UnderlinedTextStackView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/08.
//

import UIKit
import SnapKit
import Then

final class UnderlinedTextStackView: UIStackView {

  private let underlineLayer = CALayer()
  private let animatedUnderlineLayer = CALayer()
  var placeHolderString = ""
  var isEmptyState = true

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }

  private let underlineView = UIView().then {
    $0.backgroundColor = Colors.g3.color
  }

  let textView = UITextView().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 14)
    $0.textColor = Colors.black.color
    $0.returnKeyType = .default
    $0.isScrollEnabled = false
  }

  let errorLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.red.color
  }

  let numOfTextLabel = UILabel().then {
    $0.font = Fonts.Montserrat.medium.font(size: 12)
    $0.textColor = Colors.g5.color
    $0.textAlignment = .right
  }

  init(placeholder: String, maxStringNum: Int) {
    super.init(frame: .zero)
    setup(placeholder, maxStringNum)
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  private func setup(_ placeholder: String, _ maxStringNum: Int) {
    self.axis = .vertical
    self.alignment = .fill
    self.distribution = .fill
    self.spacing = 4

    self.errorLabel.isHidden = true
    self.placeHolderString = placeholder
    self.numOfTextLabel.text = "0/\(String(maxStringNum))"
  }

  private func render() {
    self.addArrangedSubviews(textView, underlineView, numOfTextLabel)
    underlineView.snp.makeConstraints { make in
      make.height.equalTo(1.5)
    }

    textView.snp.makeConstraints { make in
      make.height.equalTo(30)
    }

    numOfTextLabel.snp.makeConstraints { make in
      make.height.equalTo(18)
    }
  }
}

extension UnderlinedTextStackView {
  func textViewSelected() {
    if isEmptyState {
      textView.text = ""
      textView.textColor = Colors.black.color
    }

    let frame = underlineView.bounds
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
    self.animatedUnderlineLayer.removeFromSuperlayer()
  }

  func textViewResize() {
    let initialSize = CGSize(width: Size.screenWidth - 48, height: CGFloat.infinity)
    let estimateSize = self.textView.sizeThatFits(initialSize)
    self.textView.snp.updateConstraints { make in
      make.height.equalTo(estimateSize.height)
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
