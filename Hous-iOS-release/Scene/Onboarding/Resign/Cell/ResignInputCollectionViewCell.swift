//
//  ResignInputCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/04.
//

import UIKit

class ResignInputCollectionViewCell: UICollectionViewCell {

  let titleLabel = UILabel().then {
    $0.text = "피드백 남기기"
    $0.textColor = Colors.black.color
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }

  let reasonTextField = UITextField().then {
    $0.backgroundColor = Colors.g1.color
    $0.makeRounded(cornerRadius: 8)
    $0.placeholder = "사유 선택하기"
    $0.textColor = Colors.black.color
  }

  let reasonTextView = UnderlinedTextFieldStackView()

  let resignCheckButton = UIButton(configuration: .plain()).then {

    var attrString = AttributedString("탈퇴하겠습니다.")
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    attrString.foregroundColor = Colors.g5.color
    $0.configuration?.attributedTitle = attrString

    $0.configuration?.imagePlacement = .leading
    $0.configuration?.imagePadding = 8
    $0.configurationUpdateHandler = { btn in
      switch btn.state {
      case .normal:
        btn.configuration?.image = Images.icCheckNotOnboardSetting.image
      case .selected:
        btn.configuration?.image = Images.icCheckYesOnboardSetting.image
      default:
        break
      }
    }
  }

  let resignButton = UIButton(configuration: .filled())

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ResignInputCollectionViewCell {
  private func render() {

  }

  private func setup() {

  }
}
