//
//  UIButton+.swift
//
//
//  Created by 김민재 on 2/19/24.
//

import UIKit

public extension UIButton {

  var contentSizeWidth: CGFloat {
    return intrinsicContentSize.width
  }

  var margin: CGFloat {
    return (frame.width - contentSizeWidth) / 2
  }

  func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
    UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.setFillColor(color.cgColor)
    context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

    let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    self.setBackgroundImage(backgroundImage, for: state)
  }
}
