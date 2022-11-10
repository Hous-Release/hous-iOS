//
//  CountTodoByDayCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/10.
//

import UIKit

final class CountTodoByDayCollectionViewCell: UICollectionViewCell {

  private var countLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 16)
    $0.textColor = Colors.g5.color
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension CountTodoByDayCollectionViewCell {

  private func render() {

    addSubView(countLabel)

    countLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(26)
      make.bottom.equalToSuperview().inset(4)
    }
  }

  func setCell(_ count: Int) {
    let fullText = "총 \(String(count))개"
    let mutableAttributedString = NSMutableAttributedString(string: fullText)
    mutableAttributedString.addAttributes([
      .font: Fonts.Montserrat.semiBold.font(size: 20),
      .foregroundColor: Colors.blue.color
    ], range: (fullText as NSString).range(of: String(count)))
    countLabel.attributedText = mutableAttributedString
  }
}
