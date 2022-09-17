//
//  HousTabBarItem.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/07.
//

import UIKit

enum HousTabBarItem: String, CaseIterable {
  case hous
  case todo
  case profile
}

extension HousTabBarItem {
  var viewController: UIViewController {
    switch self {
    case .hous:
      return UINavigationController(rootViewController: MainHomeViewController(viewModel: MainHomeViewModel()))
    case .todo:
      return UINavigationController(rootViewController: TodoViewController())
    case .profile:
      return UINavigationController(rootViewController: ProfileViewController())
    }
  }

  var unselectedIcon: UIImage {
    switch self {
    case .hous:
      return Images.icHousNocheck.image
    case .todo:
      return Images.icTodoNocheck.image
    case .profile:
      return Images.icProfileNocheck.image
    }
  }

  var selectedIcon: UIImage {
    switch self {
    case .hous:
      return Images.icHousCheck.image
    case .todo:
      return Images.icTodoCheck.image
    case .profile:
      return Images.icProfileCheck.image
    }
  }

  var name: String {
    switch self {
    case .hous:
      return "Hous-"
    case .todo:
      return "To-Do"
    case .profile:
      return "Profile"
    }
  }
}
