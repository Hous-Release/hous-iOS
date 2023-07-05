//
//  SearchBarUtil.swift
//  Hous-iOS-release
//
//  Created by 김지현 on 2023/07/03.
//

import UIKit

protocol SearchBarViewProtocol {
  func addChildVC(_ viewController: UIViewController, to view: UIView)
  func removeChildVC(_ viewController: UIViewController)
}

enum SearchType: Equatable {
  case rules, todo
}
