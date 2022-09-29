//
//  UnderlinedTextField.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

class UnderlinedTextField: UITextField {

  let underlineLayer = CALayer()

  let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 38))
  let countLabel = UILabel().then {
    $0.text = "0 / 8"
    $0.font = Fonts.Montserrat.regular.font(size: 14)
    $0.textColor = Colors.g4.color
    $0.frame = CGRect(x: 0, y: 0, width: 35, height: 38)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setupUnderlineLayer()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.addSublayer(underlineLayer)
    paddingView.addSubView(countLabel)
    self.rightView = paddingView
    self.rightViewMode = .always
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupUnderlineLayer() {
    var frame = self.bounds
    frame.origin.y = frame.size.height - 1.5
    frame.size.height = 1.5

    underlineLayer.frame = frame
    underlineLayer.backgroundColor = Colors.blue.color.cgColor
  }
}
