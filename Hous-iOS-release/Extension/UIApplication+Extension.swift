//
//  UIApplication+.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/11/28.
//

import UIKit
extension UIApplication {

  var keyWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .filter { $0.activationState == .foregroundActive }
      .first(where: { $0 is UIWindowScene })
      .flatMap({ $0 as? UIWindowScene })?.windows
      .first(where: \.isKeyWindow)
  }
  var keyWindowPresentedController: UIViewController? {
    var viewController = self.keyWindow?.rootViewController
    if let presentedController = viewController as? UITabBarController {
      viewController = presentedController.selectedViewController
    }

    while let presentedController = viewController?.presentedViewController {
      if let presentedController = presentedController as? UITabBarController {
        viewController = presentedController.selectedViewController
      } else {
        viewController = presentedController
      }
    }
    return viewController
  }
}
