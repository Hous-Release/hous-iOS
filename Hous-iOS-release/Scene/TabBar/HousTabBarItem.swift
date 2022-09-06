//
//  HousTabBarItem.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2022/09/02.
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
      return UINavigationController(rootViewController: HousViewController())
    case .todo:
      return UINavigationController(rootViewController: TodoViewController())
    case .profile:
      return UINavigationController(rootViewController: ProfileViewController())
    }
  }

  var icon: UIImage? {
    switch self {
    case .hous:
      return UIImage(systemName: "star")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
    case .todo:
      return UIImage(systemName: "star")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
    case .profile:
      return UIImage(systemName: "star")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
    }
  }

  var selectedIcon: UIImage? {
    switch self {
    case .hous:
      return UIImage(systemName: "star.fill")
    case .todo:
      return UIImage(systemName: "star.fill")
    case .profile:
      return UIImage(systemName: "star.fill")
    }
  }

  var name: String {
    return self.rawValue.capitalized
  }
}
