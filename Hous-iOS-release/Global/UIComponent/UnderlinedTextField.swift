//
//  UnderlinedTextField.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/08.
//

import UIKit

class UnderlinedTextField: UITextField {

  let underlineLayer = CALayer()

  override func layoutSubviews() {
    super.layoutSubviews()
    setupUnderlineLayer()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.addSublayer(underlineLayer)
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
