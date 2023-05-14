//
//  SearchBarView.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/05/10.
//

import UIKit

import AssetKit

final class HousSearchBar: UITextField {

  private let imageContainerView = UIView()

  private let searchIconImageView = UIImageView(image: Images.icSearch.image).then {
    $0.contentMode = .scaleAspectFit
  }

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
    self.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    self.attributedPlaceholder = NSAttributedString(
      string: "검색하기", attributes: [
      NSAttributedString.Key.foregroundColor: Colors.g5.color])
    self.backgroundColor = Colors.blueL2.color
    self.leftView = imageContainerView
    self.leftViewMode = .always
    self.clearButtonMode = .whileEditing
    self.layer.cornerRadius = 8
    self.layer.borderColor = nil
    self.layer.borderWidth = 0
  }

  func setLayout() {
    self.snp.makeConstraints { make in
      make.height.equalTo(ScreenUtils.getHeight(46))
    }

    imageContainerView.addSubview(searchIconImageView)

    searchIconImageView.snp.makeConstraints { make in
      make.size.equalTo(ScreenUtils.getWidth(24))
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
      make.trailing.equalToSuperview().inset(11)
    }
  }

}
