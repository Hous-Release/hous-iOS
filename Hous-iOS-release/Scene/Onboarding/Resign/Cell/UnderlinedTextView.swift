//
//  UnderlinedTextView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit
import SnapKit
import Then

final class UnderlinedTextFieldStackView: UIStackView {

  private let underlineLayer = CALayer()
  private let animatedUnderlineLayer = CALayer()
  let placeHolderString = "의견 남기기"
  var isEmptyState = true

  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }

  private let underlineView = UIView().then {
    $0.layer.borderWidth = 1.5
    $0.layer.borderColor = Colors.g3.color.cgColor
  }

  let textView = ProfileEditTextView().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 14)
    $0.textColor = Colors.black.color
    $0.returnKeyType = .done
    $0.isScrollEnabled = false
  }

  let numOfTextLabel = UILabel().then {
    $0.font = Fonts.Montserrat.medium.font(size: 12)
    $0.textColor = Colors.black.color
    $0.textAlignment = .right
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
    self.spacing = 8
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

extension UnderlinedTextFieldStackView {
  func textViewSelected() {
    if isEmptyState {
      textView.text = ""
      textView.textColor = Colors.black.color
    }

    var frame = underlineView.bounds
    frame.size.height = 1.5
  }

  func textViewUnselected() {
    if textView.text.isEmpty {
      textView.text = placeHolderString
      textView.textColor = Colors.g5.color

      isEmptyState = true
    }
    self.underlineView.layer.borderWidth = 1.5
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
