//
//  EmptyTodoByDayCollectionViewCell.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/11.
//

import UIKit

enum EmptyTodoByDayType {
  case myTodo, ourTodo
}

final class EmptyTodoByDayCollectionViewCell: UICollectionViewCell {

  private var guideLabel = UILabel().then {
    $0.textColor = Colors.g5.color
    $0.textAlignment = .center
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension EmptyTodoByDayCollectionViewCell {

  private func render() {

    addSubView(guideLabel)

    guideLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  func setCell(_ type: EmptyTodoByDayType) {
    switch type {
    case .myTodo:
      guideLabel.font = Fonts.SpoqaHanSansNeo.regular.font(size: 14)
      guideLabel.text = "아직 담당하는 to-do가 없어요!"
    case .ourTodo:
      guideLabel.font = Fonts.SpoqaHanSansNeo.medium.font(size: 14)
      guideLabel.text = "우리집 to-do를 추가해 봐요!"
    }
  }
}
