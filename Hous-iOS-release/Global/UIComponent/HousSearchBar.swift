//
//  SearchBarView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/10.
//

import UIKit

import AssetKit

final class HousSearchBar: UISearchBar {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setStyle()
    setLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

private extension HousSearchBar {
  func setStyle() {
    self.searchTextField.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    self.searchTextField.attributedPlaceholder = NSAttributedString(
      string: "검색하기", attributes: [
      NSAttributedString.Key.foregroundColor: Colors.g5.color])
    self.searchTextField.backgroundColor = Colors.blueL2.color
    self.searchTextField.leftView?.tintColor = Colors.blue.color
    self.layer.cornerRadius = 8
  }

  func setLayout() {
    self.snp.makeConstraints { make in
      make.height.equalTo(ScreenUtils.getHeight(46))
    }
  }

}
