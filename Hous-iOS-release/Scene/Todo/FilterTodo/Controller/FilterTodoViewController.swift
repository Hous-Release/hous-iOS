//
//  FilterTodoViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit

final class FilterTodoViewController: BaseViewController, LoadingPresentable {

  private let navigationBar = NavBarWithBackButtonView(
    title: "우리 집 to-do"
  )

  private let containerView = UIView()
  let searchBarViewController = SearchBarViewController(.todo)

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.delegate = self
    configUI()

    searchBarViewController.filterView.resultCnt = 8
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTabBarIsHidden(isHidden: true)
  }

  private func configUI() {

    self.view.backgroundColor = Colors.white.color

    addChildVC(searchBarViewController, to: containerView)

    self.view.addSubViews([navigationBar, containerView])

    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(NavigationBar.height)
    }

    containerView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(navigationBar.snp.bottom)
    }
  }

}

extension FilterTodoViewController: SearchBarViewProtocol {

  func addChildVC(_ viewController: UIViewController, to view: UIView) {
    addChild(viewController)
    view.addSubView(viewController.view)
    viewController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    viewController.didMove(toParent: self)
  }

  func removeChildVC(_ viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
}

extension FilterTodoViewController: NavBarWithBackButtonViewDelegate {

  func backButtonDidTapped() {
    navigationController?.popViewController(animated: true)
  }
}
