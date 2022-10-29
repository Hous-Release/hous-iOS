//
//  NeumorphismBox.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/10/29.
//

import UIKit

final class NeumorphismBox: UIView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .white
    self.layer.cornerRadius = 30
    self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(shadowColor: CGColor, shadowOpacity: Float, shadowRadius: CGFloat) {
    self.init()
    self.layer.shadowColor = shadowColor
    self.layer.shadowOpacity = shadowOpacity
    self.layer.shadowRadius = shadowRadius
  }
}
