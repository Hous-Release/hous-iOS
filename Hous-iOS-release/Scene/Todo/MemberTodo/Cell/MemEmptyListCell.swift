//
//  MemEmptyListCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/02.
//

import UIKit
import Then
import SnapKit

final class MemEmptyListCell: UICollectionViewListCell {
  private func defaulEmptyConfiguration() -> UIListContentConfiguration {
    return .subtitleCell()
  }

  private lazy var emptyContentView = UIListContentView(configuration: defaulEmptyConfiguration())

  func update(with guideText: String) {
    emptyGuideLabel.text = guideText
    setNeedsUpdateConfiguration()
  }

  var emptyGuideLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 14)
    $0.textColor = Colors.g5.color
  }
}

extension MemEmptyListCell {
  func setupViewsIfNeeded() {
    render()
  }

  override func updateConfiguration(using state: UICellConfigurationState) {
    setupViewsIfNeeded()
  }
}

extension MemEmptyListCell {
  private func render() {
    contentView.addSubViews([emptyContentView, emptyGuideLabel])
    emptyContentView.translatesAutoresizingMaskIntoConstraints = false
    emptyContentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalTo(92)
    }
    emptyGuideLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
