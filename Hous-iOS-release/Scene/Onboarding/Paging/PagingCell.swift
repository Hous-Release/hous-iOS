//
//  PagingCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/23.
//

import UIKit

final class PagingCell: UICollectionViewCell {

  enum Size {
    static let height = UIScreen.main.bounds.height
    static let graphicSize = height * 280/812
    static let stackTopOffset = height * 30/812
    static let graphicBottomInset = height * 72/812
  }

  let stackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fillProportionally
    $0.spacing = 16
  }

  var bigTitle = UILabel().then {
    $0.text = "Welcome to\nYour Hous-"
    $0.dynamicFontMontserrat(fontSize: 32, weight: .bold)
    $0.textColor = Colors.black.color
    $0.numberOfLines = 2
    $0.lineBreakMode = .byWordWrapping
    $0.lineBreakStrategy = .hangulWordPriority
    $0.textAlignment = .left
  }

  var secondTitle = UILabel().then {
    $0.text = "Welcome to\nYour Hous-\n\n우리의 Hous-를 위한 How is-\n반가워요, 호미들!"
    $0.dynamicFontSpoqaHanSansNeo(fontSize: 16, weight: .medium)
    $0.textColor = Colors.black.color
    $0.numberOfLines = 6
    $0.lineBreakMode = .byWordWrapping
    $0.lineBreakStrategy = .hangulWordPriority
    $0.textAlignment = .left
  }

  var graphicView = UIView().then {
    $0.backgroundColor = Colors.g3.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func render() {
    stackView.addArrangedSubviews(bigTitle, secondTitle)
    addSubViews([stackView, graphicView])

    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(Size.stackTopOffset)
      make.leading.trailing.equalTo(46)
    }

    graphicView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.size.equalTo(Size.graphicSize)
      make.bottom.equalToSuperview().inset(Size.graphicBottomInset)
    }
  }
}

extension PagingCell {
  func setCell(content: PagingContent) {
    bigTitle.text = content.bigTitle
    secondTitle.text = content.secondTitle
    graphicView.largeContentImage = content.graphic
  }
}
