//
//  CheckButton.swift
//  
//
//  Created by 김지현 on 2023/05/22.
//

import UIKit
import AssetKit

public final class CheckButton: UIButton {

  public init(_ type: Button.Check) {
    super.init(frame: .zero)
    configUI(type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI(_ type: Button.Check) {
    configuration = .plain()

    var attrString = AttributedString(type.title)
    attrString.font = HousFont.B3.font
    configuration?.attributedTitle = attrString

    configuration?.baseBackgroundColor = Colors.white.color
    configuration?.imagePlacement = .leading
    configuration?.imagePadding = 4

    configurationUpdateHandler = { btn in
      switch btn.state {
      case .selected:
        btn.configuration?.baseForegroundColor = type.activeTitleColor
        btn.configuration?.image = type.selectedCheckImage
      case .normal:
        btn.configuration?.baseForegroundColor = type.disabledTitleColor
        btn.configuration?.image = type.unselectedCheckImage
      default:
        break
      }
    }

  }

}
