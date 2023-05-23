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
    configUI()
  }

  private func configUI() {

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

  func addChildVC(_ vc: UIViewController, to view: UIView) {
    addChild(vc)
    view.addSubView(vc.view)
    vc.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    vc.didMove(toParent: self)
  }

  func removeChildVC(_ vc: UIViewController) {
    vc.willMove(toParent: nil)
    vc.view.removeFromSuperview()
    vc.removeFromParent()
  }
}
