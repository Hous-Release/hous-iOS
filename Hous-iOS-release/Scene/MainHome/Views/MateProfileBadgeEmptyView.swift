//
//  MateProfileBadgeEmptyView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit

final class MateProfileBadgeEmptyView: UIView {
  
  var personalityColor : PersonalityColor = .none
  
  override func draw(_ rect: CGRect) {
    let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 52, height: 52))
    var backgroundColor = UIColor()
    
    switch personalityColor {
    case .red:
      backgroundColor = Colors.redB1.color
    case .yellow:
      backgroundColor = Colors.yellowB1.color
    case .blue:
      backgroundColor = Colors.blueL1.color
    case .green:
      backgroundColor = Colors.greenB1.color
    case .purple:
      backgroundColor = Colors.purpleB1.color
    case .none:
      backgroundColor = Colors.g1.color
    }

    backgroundColor.setFill()
    path.fill()
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = Colors.white.color
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
}
