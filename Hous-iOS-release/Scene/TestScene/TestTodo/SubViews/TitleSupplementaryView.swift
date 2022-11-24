//
//  TitleSupplementaryView.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/14.
//

import AssetKit
import UIKit

final class TitleSupplementaryView: UICollectionReusableView {

  private struct Constants {
    static let verticalMargin: CGFloat = 12
    static let horizontalMargin: CGFloat = 24
  }
  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  required init?(coder: NSCoder) {
    fatalError()
  }
}

extension TitleSupplementaryView {
  func configure() {
    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontForContentSizeCategory = true
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      label.topAnchor.constraint(equalTo: topAnchor, constant: Constants.verticalMargin),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.verticalMargin)
    ])
    label.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
  }
}

