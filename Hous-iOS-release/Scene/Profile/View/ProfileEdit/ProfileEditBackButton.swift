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
    self.setImage(Images.icBack.image, for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

enum ProfileEditBackButtonState {
  case valid
  case notSaved
}
