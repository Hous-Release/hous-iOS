//
//  ByDayHeaderCollectionReusableView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/11/10.
//

import UIKit

class ByDayHeaderCollectionReusableView: UICollectionReusableView {

  var titleLabel = UILabel().then {
    $0.font = Fonts.Montserrat.semiBold.font(size: 18)
    $0.text = "My to-do"
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ByDayHeaderCollectionReusableView {
  private func render() {
    addSubView(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(24)
    }
  }

  func setHeader(_ sectionType: ByDayTodoSection.Section) {
    var title = ""
    switch sectionType {
    case .countTodo, .myTodoEmpty, .ourTodoEmpty:
      title = ""
    case .myTodo:
      title = "My to-do"
    case .ourTodo:
      title = "Our to-do"
    }
    titleLabel.text = title
  }
}
