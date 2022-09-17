//
//  TodoFooterCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/16.
//

import UIKit

import SnapKit
import Then

final class TodoFooterCollectionReusableView: UICollectionReusableView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setUp() {

    let border = CALayer()
    border.frame = CGRect(x: 24, y: self.frame.size.height * 0.56, width: self.frame.width - 48, height: 1)
    border.backgroundColor = Colors.g2.color.cgColor
    self.layer.addSublayer(border)
  }
}
