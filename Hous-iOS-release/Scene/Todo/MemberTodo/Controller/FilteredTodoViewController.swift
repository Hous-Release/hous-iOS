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
  case member, byDay
}

//MARK: - Controller
final class FilteredTodoViewController: UIViewController {

  var disposeBag = DisposeBag()

  var viewType: FilteringType = .member {
    didSet {
      var attrString = AttributedString()

      if viewType == .member {
        attrString = AttributedString("요일별 보기")
        removeChildVC(byDayTodoViewController)
        addChildVC(memberTodoViewController)
        navigationBar.title = "멤버별 보기"
      } else if viewType == .byDay {
        attrString = AttributedString("멤버별 보기")
        removeChildVC(memberTodoViewController)
        addChildVC(byDayTodoViewController)
        navigationBar.title = "요일별 보기"
      }
      attrString.font = Fonts.SpoqaHanSansNeo.medium.font(size: 12)
      attrString.foregroundColor = Colors.g5.color
      navigationBar.rightButton.configuration?.attributedTitle = attrString
    }
  }

  enum Size {
    static let navigationBarHeight = 64
  }

  var navigationBar = NavBarWithBackButtonView(title: "멤버별 보기", rightButtonText: "요일별 보기").then {
    $0.backgroundColor = Colors.g1.color
    $0.rightButton.configuration?.imagePadding = 2
    $0.rightButton.configuration?.imagePlacement = .trailing
    $0.rightButton.configuration?.image = Images.icChange.image
    $0.rightButton.configuration?.baseForegroundColor = Colors.g5.color
  }
  private var contentsView = UIView()

  let serviceProvider = ServiceProvider()

  lazy var memberTodoViewReactor = MemberTodoViewReactor(provider: serviceProvider)
  lazy var memberTodoViewController = MemberTodoViewController(memberTodoViewReactor)

  lazy var byDayTodoViewReactor = ByDayTodoViewReactor(provider: serviceProvider)
  lazy var byDayTodoViewController = ByDayTodoViewController(byDayTodoViewReactor)

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: true)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    render()
    bindNavRightButton()
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
    vc.view.removeFromSuperview()
    vc.removeFromParent()
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

  private func bindNavRightButton() {
    navigationBar.rightButton.rx.tap
      .subscribe { [weak self] _ in
        self?.viewType == .member ? (self?.viewType = .byDay) : (self?.viewType = .member)
      }
      .disposed(by: disposeBag)
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
