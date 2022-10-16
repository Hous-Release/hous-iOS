//
//  FilteredTodoView.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/15.
//

import UIKit

import SnapKit
import Then

enum FilteringType {
  case member, dayOfWeek
}

final class FilteredTodoView: UIView {

  var viewType: FilteringType = .member {
    didSet {
      // FilteringType 에 따른 뷰 변경
      if viewType == .member {
        contentsView.addSubView(memberTodoView)
      }
    }
  }

  enum Size {
    static let navigationBarHeight = 64
  }

  lazy var memberTodoView = MemberTodoView()
  // lazy var dayOfWeekView = DayOfWeekView()

  var navigationBar = NavBarWithBackButtonView(title: "멤버별 보기", rightButtonText: "요일별 보기").then {
    $0.backgroundColor = Colors.g1.color
    var config = UIButton.Configuration.plain()
    config.imagePlacement = .trailing
    config.image = Images.icChange.image
    config.baseForegroundColor = Colors.g5.color
    $0.rightButton.configuration = config
  }
  private var contentsView = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    render()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FilteredTodoView {

  private func render() {
    addSubViews([navigationBar, contentsView])

    navigationBar.snp.makeConstraints { make in
      make.height.equalTo(Size.navigationBarHeight)
      make.top.leading.trailing.equalToSuperview()
    }

    contentsView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
}
