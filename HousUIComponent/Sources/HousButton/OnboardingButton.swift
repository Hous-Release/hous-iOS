//
//  OnboardingButton.swift
//  
//
//  Created by 김지현 on 2023/05/21.
//

import UIKit
import AssetKit

public final class OnboardingButton: UIButton {

  init(_ type: Button.Onboarding) {
    super.init(frame: .zero)
    configUI(type)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configUI(_ type: Button.Onboarding) {
    configuration = .bordered()

    var attrString = AttributedString(type.rawValue)
    attrString.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    attrString.foregroundColor = Colors.white.color
    configuration?.attributedTitle = attrString

    configuration?.background.cornerRadius = 0
    configuration?.cornerStyle = .fixed
    configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)

    updateHandlerByType(type)
  }

  private func updateHandlerByType(_ type: Button.Onboarding) {

    configurationUpdateHandler = { btn in
      switch btn.state {
      case .normal:
        switch type {
        case .next, .createRoom:
          btn.configuration?.baseBackgroundColor = Colors.blue.color
        case .leaveProfile:
          btn.configuration?.baseBackgroundColor = Colors.red.color
        }

      case .disabled:
        switch type {
        case .next, .createRoom:
          btn.configuration?.baseBackgroundColor = Colors.g4.color
        case .leaveProfile:
          btn.configuration?.baseBackgroundColor = Colors.redB1.color
        }

      default:
        break
      }
    }

  }

}
