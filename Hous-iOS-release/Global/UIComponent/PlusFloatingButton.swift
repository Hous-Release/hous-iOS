//
//  PlusFloatingButton.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/14.
//

import UIKit

final class PlusFloatingButton: UIButton {

  private enum Size {
    static let floatingButtonSize = ScreenUtils.getWidth(60)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension PlusFloatingButton {
  func setLayout() {
    self.setImage(Images.btnAddFloating.image, for: .normal)
    self.snp.makeConstraints { make in
      make.size.equalTo(Size.floatingButtonSize)
    }
  }

}
