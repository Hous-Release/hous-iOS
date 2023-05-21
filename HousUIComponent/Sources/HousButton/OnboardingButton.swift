//
//  OnboardingButton.swift
//  
//
//  Created by 김지현 on 2023/05/21.
//

import UIKit
import AssetKit

public final class OnboardingButton: UIButton {

  public init(_ type: Button.Onboarding) {
    super.init(frame: .zero)
    configUI(type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI(_ type: Button.Onboarding) {
    configuration = .bordered()

    var attrString = AttributedString(type.title)
    attrString.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    attrString.foregroundColor = type.activeTitleColor
    configuration?.attributedTitle = attrString

    configuration?.background.cornerRadius = 0
    configuration?.cornerStyle = .fixed
    configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)

    configurationUpdateHandler = { btn in

      switch btn.state {
      case .normal:
        btn.configuration?.baseBackgroundColor = type.activeBackgroundColor

      case .disabled:
        btn.configuration?.baseBackgroundColor = type.disabledBackgroundColor

      default:
        break
      }
    }

  }

}
