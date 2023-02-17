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
    navigationController?.delegate = self
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
extension BaseViewController: UINavigationControllerDelegate { }
