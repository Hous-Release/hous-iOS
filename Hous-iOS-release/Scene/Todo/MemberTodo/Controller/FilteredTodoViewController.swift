//
//  FilteredTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/10/15.
//

import UIKit

import RxCocoa
import RxDataSources
import ReactorKit

// Todo: FilteredTodoViewController - containerVC / memberTodoViewController & dayOfWeekViewController - contentsVC

enum FilteringType {
  case member, dayOfWeek
}

//MARK: - Controller
final class FilteredTodoViewController: UIViewController{

  var viewType: FilteringType = .member {
    didSet {
      // FilteringType 에 따른 뷰 변경
      let serviceProvider = ServiceProvider()
      let memberTodoViewReactor = MemberTodoViewReactor(provider: serviceProvider)
      let memberTodoViewController = MemberTodoViewController(memberTodoViewReactor)

      if viewType == .member {
        addChildVC(memberTodoViewController)
      }
    }
  }

  enum Size {
    static let navigationBarHeight = 64
  }

  // question: 이게 맞을까? .... 아닌 것 같아 ....

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

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    render()
  }
}

extension FilteredTodoViewController {
  private func addChildVC(_ vc: UIViewController) {
    addChild(vc)
    contentsView.addSubView(vc.view)
    vc.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    vc.didMove(toParent: self)
  }

  private func removeChildVC(_ vc: UIViewController) {
    vc.willMove(toParent: nil)
    vc.removeFromParent()
    vc.view.removeFromSuperview()
  }
}

extension FilteredTodoViewController {
  private func setup() {
    navigationController?.navigationBar.isHidden = true
    navigationBar.delegate = self
    view.backgroundColor = Colors.white.color
    viewType = .member
  }

  private func render() {
    view.addSubViews([navigationBar, contentsView])

    navigationBar.snp.makeConstraints { make in
      make.height.equalTo(Size.navigationBarHeight)
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
    }

    contentsView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension FilteredTodoViewController: NavBarWithBackButtonViewDelegate {
  func backButtonDidTappedWithoutPopUp() {
    print("back")
  }

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
