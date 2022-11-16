//
//  SceneDelegate.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/08/13.
//

import KakaoSDKAuth
import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
//    let serviceProvider = ServiceProvider()
//    let reactor = SplashReactor(provider: serviceProvider)
//    window.rootViewController = SplashViewController(reactor)


    let homies: [UpdateTodoHomieModel] = [
      .init(name: "호세", color: .brown, selectedDay: [.fri]),
      .init(name: "지현", color: .cyan, selectedDay: [.mon])
    ]

    let serviceProvider = ServiceProvider()

    let reactor = UpdateTodoReactor(
      provider: serviceProvider,
      state: .init()
    )

    window.rootViewController = UpdateTodoViewController(reactor, homies)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    self.window = window
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      if (AuthApi.isKakaoTalkLoginUrl(url)) {
        _ = AuthController.handleOpenUrl(url: url)
      }
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) { }

  func sceneDidBecomeActive(_ scene: UIScene) { }

  func sceneWillResignActive(_ scene: UIScene) { }

  func sceneWillEnterForeground(_ scene: UIScene) { }

  func sceneDidEnterBackground(_ scene: UIScene) { }


}

