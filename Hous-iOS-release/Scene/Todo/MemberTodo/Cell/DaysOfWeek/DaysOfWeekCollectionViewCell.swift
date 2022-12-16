//
//  DaysOfWeekCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/10.
//

import UIKit
import Then
import ReactorKit

final class DaysOfWeekCollectionViewCell: UICollectionViewCell {

  var dayButton = UIButton(configuration: UIButton.Configuration.filled())
  var triangleView = TriangleView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUp()
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var isSelected: Bool {
    didSet {
      if isSelected {
        triangleView.isHidden = false
        dayButton.isSelected = true
      }
      else {
        triangleView.isHidden = true
        dayButton.isSelected = false
      }
    }
  }
}

extension DaysOfWeekCollectionViewCell {
  private func setUp() {
    dayButton.configurationUpdateHandler = { btn in
      switch btn.state {
      case .normal:
        btn.configuration?.baseForegroundColor = Colors.g5.color
        btn.configuration?.baseBackgroundColor = Colors.g1.color
      case .selected:
        btn.configuration?.baseForegroundColor = Colors.white.color
        btn.configuration?.baseBackgroundColor = Colors.blue.color
      default:
        break
      }
    }
    dayButton.configuration?.cornerStyle = .capsule
    dayButton.isUserInteractionEnabled = false
    dayButton.configuration?.titleAlignment = .center
    triangleView.backgroundColor = .clear
    triangleView.isHidden = true
  }

  private func render() {
    addSubViews([dayButton, triangleView])
    dayButton.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.size.equalTo(40)
    }
    triangleView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview()
      make.size.equalTo(4)
    }
  }

  func setCell(_ day: String) {
    var attributedString = AttributedString(day)
    attributedString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    dayButton.configuration?.attributedTitle = attributedString
  }
}
