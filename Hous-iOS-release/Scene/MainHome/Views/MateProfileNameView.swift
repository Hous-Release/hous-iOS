//
//  MateProfileBadgeEmptyView.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/16.
//

import UIKit

final class MateProfileNameView: UIView {
  
  private enum Size {
    static let screenWidth = UIScreen.main.bounds.width
  }
  
  override func draw(_ rect: CGRect) {
    let pathPoints = [
      CGPoint(x: 0, y: 0),
      CGPoint(x: 0, y: 41),
      CGPoint(x: Size.screenWidth, y: 45),
      CGPoint(x: Size.screenWidth, y: 43),
      CGPoint(x: 127, y: 39),
      CGPoint(x: 127, y: 0)
    ]
    
    let roundedPath = UIBezierPath.roundedCornersPath(pathPoints, 10)

    Colors.white.color.setFill()
    roundedPath!.fill()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
}
