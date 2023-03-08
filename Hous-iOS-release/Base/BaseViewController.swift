//
//  LoadingBaseViewController.swift
//  Hous-iOS-release
//
//  Created by 김민재 on 2022/11/16.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.delegate = self
  }

  func showLoading() {
    DispatchQueue.main.async {
      self.presentLoading()
    }
  }

  func hideLoading() {
    DispatchQueue.main.async {
      self.dismissLoading()
    }
  }
}

extension BaseViewController: LoadingPresentable { }
extension BaseViewController: ErrorHandler { }

extension BaseViewController: UINavigationControllerDelegate {

  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    navigationController
      .interactivePopGestureRecognizer?
      .isEnabled = navigationController.viewControllers.count > 1
  }
}
