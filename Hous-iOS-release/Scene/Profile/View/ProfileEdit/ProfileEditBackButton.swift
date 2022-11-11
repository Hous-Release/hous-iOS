//
//  ProfileEditBackButton.swift
//  Hous-iOS-release
//
//  Created by 이의진 on 2022/11/11.
//

import UIKit

final class ProfileEditBackButton: UIButton {
  
  var buttonState: ProfileEditBackButtonState = .valid
  override init(frame: CGRect) {
    super.init(frame: frame)
    let image = Images.icBack.image
    let newWidth = 28
    let newHeight = 28
    let newImageRect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: newImageRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    UIGraphicsEndImageContext()
    self.setImage(newImage, for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

enum ProfileEditBackButtonState {
  case valid
  case notSaved
}
