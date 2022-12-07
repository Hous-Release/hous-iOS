//
//  GrayBackgroundTextField.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/12/07.
//

import UIKit
import AssetKit

class GrayBackgroundTextField: UITextField {

  let customRightView = UIView()
  let arrowImageView = UIImageView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    customRightView.addSubView(arrowImageView)

    arrowImageView.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.trailing.equalToSuperview().inset(8)
      make.size.equalTo(24)
    }
  }

  private func setup() {

    arrowImageView.image = Images.icDown.image

    backgroundColor = Colors.g1.color
    makeRounded(cornerRadius: 8)
    placeholder = "사유 선택하기"
    textColor = Colors.black.color
    font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)

    addLeftPadding(12)
    rightView = customRightView
    rightViewMode = .always
  }
}
