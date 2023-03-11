//
//  MainCoordinator.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/03/08.
//

import UIKit

final class MainCoordinator: Coordinator, SplashViewControllerDelegate {

  var childCoordinators: [Coordinator] = []

  var navigationController: UINavigationController?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let serviceProvider = ServiceProvider()
    let reactor = SplashReactor(provider: serviceProvider)
    let splashVC = SplashViewController(reactor)

    splashVC.delegate = self

    navigationController?.pushViewController(splashVC, animated: false)
  }

  func transferForSuccess(_ isJoiningRoom: Bool) {
    let tvc = HousTabbarViewController()
    let enterRoomVC = EnterRoomViewController()

    if isJoiningRoom {
      changeRootViewController(to: tvc)
      return
    }
    changeRootViewController(to: UINavigationController(rootViewController: enterRoomVC))
//    if !isJoiningRoom {
//      changeRootViewController(to: UINavigationController(rootViewController: enterRoomVC))
//      return
//    }
  }

  func transferOnboarding(_ isOnboardingFlow: Bool) {
    guard isOnboardingFlow else { return }

    let onboardingVC = PagingViewController()
    changeRootViewController(to: onboardingVC)
  }

  func transferLogin(_ isLoginFlow: Bool) {
    guard isLoginFlow else { return }

    let serviceProvider = ServiceProvider()
    let reactor = SignInReactor(provider: serviceProvider)
    let loginVC = SignInViewController(reactor)
    changeRootViewController(to: UINavigationController(rootViewController: loginVC))
  }
}

extension MainCoordinator {
  private func changeRootViewController(to rootVC: UIViewController) {
    navigationController?.view.window?.rootViewController?.dismiss(animated: false) {

      rootVC.modalPresentationStyle = .fullScreen

      guard
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
      else { return }

      sceneDelegate.window?.rootViewController = rootVC
      sceneDelegate.window?.makeKeyAndVisible()
    }
  }
}
