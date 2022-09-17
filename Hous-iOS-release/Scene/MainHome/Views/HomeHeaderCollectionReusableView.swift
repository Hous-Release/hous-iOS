//
//  HomeHeaderCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/09/11.
//

import UIKit
import Then
import SnapKit

class HomeHeaderCollectionReusableView: UICollectionReusableView {
  
  static let identifier = "HomeHeaderCollectionReusableView"
  
  let subtitleLabel = UILabel().then {
    $0.font = Fonts.Montserrat.semiBold.font(size: 18)
    $0.textColor = Colors.black.color
    $0.textAlignment = .left
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configUI() {
    addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(24)
      make.leading.equalToSuperview().offset(32)
      make.trailing.bottom.equalToSuperview()
    }
  }
  
  func setSubTitleLabel(string: String) {
    subtitleLabel.text = string
  }
}
