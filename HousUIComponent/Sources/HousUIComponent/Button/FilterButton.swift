//
//  FilterButton.swift
//  
//
//  Created by 김지현 on 2023/06/04.
//

import UIKit
import AssetKit

public final class FilterButton: UIButton {

  public init(_ type: Button.Filter = .def) {
    super.init(frame: .zero)
    configUI(type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI(_ type: Button.Filter) {
    configuration = .plain()

    var attrString = AttributedString(type.title)
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    configuration?.attributedTitle = attrString

    configuration?.image = Images.icFilter.image
    configuration?.imagePlacement = .leading
    configuration?.imagePadding = 6

    configurationUpdateHandler = { btn in
      switch btn.state {
      case .selected:
        btn.configuration?.baseForegroundColor = type.disabledTitleColor
        btn.configuration?.baseBackgroundColor = type.disabledBackgroundColor
      case .normal:
        btn.configuration?.baseForegroundColor = type.activeTitleColor
        btn.configuration?.baseBackgroundColor = type.activeBackgroundColor
      default:
        break
      }
    }

  }

}
