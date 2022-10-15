//
//  MemberCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/14.
//

import UIKit
import Then
import ReactorKit

final class MemberCollectionViewCell: UICollectionViewCell {

  enum Size {
    static let buttonWidth = (40/375) * UIScreen.main.bounds.width
  }

  // var memberColor 민재 code Factory Pattern

  var checkButton = UIButton().then {
    $0.configurationUpdateHandler = { btn in
      var config = btn.configuration
      config?.imagePlacement = .top
      config?.title = "김지현"
      var titleAttr = AttributedString()
      titleAttr.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)

      switch btn.state {
      case .normal:
        config?.image = Images.icBlueNo.image
        config?.baseForegroundColor = Colors.g5.color
      case .selected:
        config?.image = Images.icBlueYes.image
        config?.baseForegroundColor = Colors.black.color
      default:
        break
      }
    }
  }
}
