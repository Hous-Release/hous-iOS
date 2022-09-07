//
//  HousTabBarViewController.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/07.
//

import UIKit

import RxSwift
import SnapKit

class HousTabbarViewController: UITabBarController {

  public let housTabBar: HousTabBar = {
    let tabbar = HousTabBar()
    return tabbar
  }()

  // MARK: - Properties

  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    setUp()
    bind()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func render() {
    view.addSubview(housTabBar)
    housTabBar.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(80)
    }
  }

  private func setUp() {
    tabBar.isHidden = true
    selectedIndex = 0
    let controllers = HousTabBarItem.allCases.map { $0.viewController }
    setViewControllers(controllers, animated: true)
  }

  func selectTabWith(index: Int) {
    self.selectedIndex = index
  }

  private func bind() {
    housTabBar.itemTapped
      .bind { [weak self] in self?.selectTabWith(index: $0) }
      .disposed(by: disposeBag)
  }
}
