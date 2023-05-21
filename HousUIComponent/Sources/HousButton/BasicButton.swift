//
//  BasicButton.swift
//  
//
//  Created by 김지현 on 2023/05/21.
//

import UIKit
import AssetKit

public final class BasicButton: UIButton {

  init(_ type: Button.Basic) {
    super.init(frame: .zero)
    configUI(type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI(_ type: Button.Basic) {
    configuration = .bordered()

    var attrString = AttributedString(type.title)
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 16)
    attrString.foregroundColor = type.activeTitleColor
    configuration?.attributedTitle = attrString

    configuration?.background.cornerRadius = 8
    configuration?.cornerStyle = .fixed
    configuration?.baseBackgroundColor = type.activeBackgroundColor

  }

}
