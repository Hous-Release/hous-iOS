//
//  HomeCoordinator.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2023/03/08.
//

import UIKit

final class HomeCoordinator: Coordinator, MainHomeViewControllerDelegate {

  var childCoordinators: [Coordinator] = []

  var navigationController: UINavigationController

  init(navigationController: UINavigationController = UINavigationController()) {
    self.navigationController = navigationController
  }

  func start() {
    let viewController = MainHomeViewController(viewModel: MainHomeViewModel())
    viewController.delegate = self

    self.navigationController.viewControllers = [viewController]
  }

  func editHousName(initname: String) {
    self.navigationController
      .pushViewController(
      EditHousNameViewController(roomName: initname),
      animated: true
      )
  }
}
