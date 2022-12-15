//
//  NextButton.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/15.
//

import UIKit

class NextButton: UIButton {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.configuration = .bordered()

    var attrString = AttributedString("다음으로")
    attrString.font = Fonts.SpoqaHanSansNeo.bold.font(size: 18)
    attrString.foregroundColor = Colors.white.color
    configuration?.attributedTitle = attrString

    configuration?.background.cornerRadius = 0
    configuration?.cornerStyle = .fixed
    configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)

    configurationUpdateHandler = { btn in
      switch btn.state {
      case .normal:
        btn.configuration?.baseBackgroundColor = Colors.blue.color
      case .disabled:
        btn.configuration?.baseBackgroundColor = Colors.g4.color
      default:
        break
      }
    }
  }
}
