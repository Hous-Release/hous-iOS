//
//  BaseView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/10.
//

import UIKit

protocol BaseViewProtocol: UIView {
    func setLayout()
    func setStyle()
}

extension BaseViewProtocol {
  func setStyle() {
    self.backgroundColor = Colors.white.color
  }
}
