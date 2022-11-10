//
//  OurTodoByDayCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/09.
//

import UIKit

final class OurTodoByDayCollectionViewCell: UICollectionViewCell {

  private var dotView = UIView().then {
    $0.backgroundColor = Colors.g3.color
    $0.layer.cornerRadius = 4
  }

  private var myTodoLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
    $0.textColor = Colors.g5.color
    $0.text = "블라블라블라"
  }

  private var assigneeLabel = UILabel().then {
    $0.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    $0.textColor = Colors.g3.color
    $0.text = "최인영, 최소현"
    $0.textAlignment = .right
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension OurTodoByDayCollectionViewCell {

  private func render() {

    [dotView, myTodoLabel, assigneeLabel].forEach { addSubview($0) }

    dotView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(26).priority(.high)
      make.centerY.equalToSuperview()
      make.size.equalTo(8)
    }

    myTodoLabel.snp.makeConstraints { make in
      make.leading.equalTo(dotView.snp.trailing).offset(12)
      make.centerY.equalToSuperview()
    }

    assigneeLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(26).priority(.high)
      make.leading.equalTo(myTodoLabel.snp.trailing)
      make.centerY.equalToSuperview()
      make.width.lessThanOrEqualTo(75)
    }
  }

  func setCell(_ todoName: String, _ assignee: [String]) {
    myTodoLabel.text = todoName
    //assigneeLabel.text = assignee
  }
}
