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

  private let backgroundView: UIView = {
    let view = UIView()
    view.layer.applySketchShadow(color: Colors.black.color, alpha: 0.05, x: 0, y: -4, blur: 10, spread: 0)
    view.layer.cornerRadius = 20
    return view
  }()

  // MARK: - Properties

  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    render()
    setUp()
    bind()
    setChangeTabBarIndex()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  private func render() {
    view.addSubview(backgroundView)
    backgroundView.addSubview(housTabBar)
    backgroundView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(80)
    }
    housTabBar.snp.makeConstraints { make in
      make.edges.equalToSuperview()
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
      .bind { [weak self] in
        guard let nvc = self?.viewControllers?[$0] as? UINavigationController else { return }
        nvc.popToRootViewController(animated: false)
        
        self?.selectTabWith(index: $0)
        
      }
      .disposed(by: disposeBag)
  }
  
  private func setChangeTabBarIndex() {
    guard let mainNVC = self.viewControllers?[0] as? UINavigationController,
          let mainVC = mainNVC.viewControllers[0] as? MainHomeViewController
    else {
      return
    }
    
    mainVC.todoBackgroundViewDidTap
      .withUnretained(self)
      .subscribe(onNext: { (owner, _) in
        owner.housTabBar.todoBackgroundViewDidTapped.onNext(())
      })
      .disposed(by: disposeBag)
  }
}
