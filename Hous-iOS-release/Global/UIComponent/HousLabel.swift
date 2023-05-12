//
//  HousLabel.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/10.
//

import UIKit

import AssetKit

final class HousLabel: UILabel {

  init(text: String?, font: UIFont, textColor: UIColor) {
    super.init(frame: .zero)
    setStyle(text: text, font: font, textColor: textColor)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setStyle(text: String?,
                        font: UIFont,
                        textColor: UIColor) {
    self.text = text
    self.font = font
    self.textColor = textColor
  }
}
