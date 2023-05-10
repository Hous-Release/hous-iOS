//
//  SearchBarView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/10.
//

import UIKit

import AssetKit

final class SearchBarView: BaseView {
  private let searchIconImageView = UIImageView().then {
    $0.image = Images.icSearch.image
  }

  private let textField = UITextField()

  override func setStyle() {
    self.backgroundColor = Colors.blueL2.color
    self.layer.cornerRadius = 8
  }

  override func setLayout() {
    self.addSubViews([
      searchIconImageView,
      textField
    ])

    
  }

  



}
