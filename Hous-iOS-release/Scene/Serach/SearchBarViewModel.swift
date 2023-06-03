//
//  SearchBarViewModel.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/05/23.
//

import UIKit

protocol SearchBarViewProtocol {
  func addChildVC(_ viewController: UIViewController, to view: UIView)
  func removeChildVC(_ viewController: UIViewController)
}

enum SearchBarViewType {
  case rules, todo
}
