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

      //let nvc = UINavigationController(rootViewController: rootVC)
      rootVC.modalPresentationStyle = .fullScreen

      guard
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
      else { return }

      sceneDelegate.window?.rootViewController = rootVC
      sceneDelegate.window?.makeKeyAndVisible()
    }
  }
  
  func setTabBarIsHidden(isHidden: Bool) {
    if let tvc = navigationController?.tabBarController as? HousTabbarViewController {
      tvc.backgroundView.isHidden = isHidden
    }
  }
}
