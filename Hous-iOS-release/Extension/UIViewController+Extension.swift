//
//  UIViewController+Extension.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/10/03.
//

import UIKit

extension UIViewController {

  func changeRootViewController(to rootVC: UIViewController) {
    self.view.window?.rootViewController?.dismiss(animated: false) {

      let nvc = UINavigationController(rootViewController: rootVC)
      nvc.modalPresentationStyle = .fullScreen

      guard
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
      else { return }

      sceneDelegate.window?.rootViewController = nvc
      sceneDelegate.window?.makeKeyAndVisible()
    }
  }
}
