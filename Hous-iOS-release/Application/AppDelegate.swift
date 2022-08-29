//
//  AppDelegate.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/08/13.
//

import UIKit
import Analytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    AppLogService.Firebase.configure()
    AppLogService.Firebase.logEvent(
      event: .appStart,
      parameter: [:]
    )

    return true
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }


}

