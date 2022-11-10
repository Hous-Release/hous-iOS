//
//  MyTodoByDayCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/09.
//

import UIKit

final class MyTodoByDayCollectionViewCell: UICollectionViewCell {

  private var dotView = UIView().then {
    $0.backgroundColor = Colors.g3.color
    $0.layer.cornerRadius = 4
  }

  private var myTodoLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.regular.font(size: 14)
    $0.textColor = Colors.black.color
    $0.text = "블라블라블라"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MyTodoByDayCollectionViewCell {

  private func render() {

    [dotView, myTodoLabel].forEach { addSubview($0) }

    dotView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(26)
      make.centerY.equalToSuperview()
      make.size.equalTo(8)
    }

    myTodoLabel.snp.makeConstraints { make in
      make.leading.equalTo(dotView.snp.trailing).offset(12)
      make.centerY.equalToSuperview()
    }
  }

  func setCell(_ todoName: String) {
    myTodoLabel.text = todoName
  }
}
