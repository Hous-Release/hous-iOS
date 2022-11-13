//
//  DayCell.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/13.
//

import AssetKit
import UIKit

final class DayCell: UICollectionViewCell {
  private struct Constants {
    static let dayButtonSize: CGSize = CGSize(width: 40, height: 40)
//    static let verticalMargin: CGFloat = 4
//    static let horizontalMargin: CGFloat = 6
    static let distance: CGFloat = 8
  }

  private let containerView: UIView = {
    let view = UIView()
    view.layer.cornerCurve = .continuous
    return view
  }()

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 8

    return stackView
  }()


  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()


    print("dho dkSEj")
  }

  required init?(coder: NSCoder) {
    fatalError("Not Implemnted")
  }
  func configure(_ model: TestHomie) {
    print("Daycell Model", model)
  }

  private func makeDayButton(_ day: TestHomie.Day) -> UIButton {
    let button = UIButton()
    button.setTitle(day.description, for: .normal)
    button.layer.cornerCurve = .circular
    button.layer.cornerRadius = Constants.dayButtonSize.height / 2
    button.titleLabel?.font = Fonts.SpoqaHanSansNeo.medium.font(size: 13)

    button.accessibilityIdentifier = day.description

    button.setBackgroundColor(Colors.g1.color, for: .normal)
    button.setTitleColor(Colors.g4.color, for: .normal)
    button.setBackgroundColor(Colors.blueL1.color, for: .selected)
    button.setTitleColor(Colors.blue.color, for: .selected)
    return button
  }

  private func setupViews() {
    contentView.backgroundColor = Colors.white.color
    contentView.addSubview(containerView)
    containerView.addSubview(stackView)

    containerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    for day in TestHomie.Day.allCases {
      stackView.addArrangedSubviews(makeDayButton(day))
    }

  }
}
