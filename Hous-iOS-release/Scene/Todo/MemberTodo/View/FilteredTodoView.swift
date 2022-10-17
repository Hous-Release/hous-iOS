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
    var attrString = AttributedString("요일별 보기")

    config.image = Images.icChange.image
    config.imagePlacement = .trailing
    attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
    attrString.foregroundColor = Colors.g5.color
    config.imagePadding = 2
    config.attributedTitle = attrString
    $0.rightButton.configuration = config
  }
  private var contentsView = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.white.color
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
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }

    contentsView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

//  private func setUp() {
//
//
//    var titleAttr = AttributedString.init("요일별 보기")
//    titleAttr.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
//    titleAttr.foregroundColor = Colors.g5.color
//    config.attributedTitle = titleAttr
//
//  }
}
