//
//  AppDelegate.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/08/13.
//

@_exported import AssetKit

import FirebaseWrapper
import RxReachability
import Reachability
import RxSwift
import UIKit
import UserInformation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var reachability: Reachability?
  private var disposeBag = DisposeBag()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {


    startReachability()
    reactionForNetwork()

    FirebaseConfigureService.Firebase.configure()
    MessagingService.Firebase.configure()

    registerRemoteNotification()

    AppLogService.Firebase.logEvent(
      event: .appStart,
      parameter: [:]
    )

    print("AccessToken === ", Keychain.shared.getAccessToken() ?? "")
    print("RefreshToken === ", Keychain.shared.getRefreshToken() ?? "")

    removeKeychainAtFirstLaunch()

    return true
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }

}

extension AppDelegate {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
    print("deviceToken: \(deviceTokenString)")


    MessagingService.Firebase.registerDeviceToken(deviceToken: deviceToken)
    MessagingService.Firebase.getFCMToken { token, err in

      guard let token = token else {
        debugPrint("FCM Token Error 발생 Description: ", err!)
        return
      }

      Keychain.shared.setFCMToken(fcmToken: token)
    }
  }

  func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
  }

}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate : UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.alert, .badge, .sound])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}

// MARK: - Method

extension AppDelegate {
  private func registerRemoteNotification() {
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    center.requestAuthorization(options: options) { granted, _ in
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
        print("Permission granted: \(granted)")
      }
    }
  }

  private func removeKeychainAtFirstLaunch() {
    guard UserInformation.isFirstLaunch() else {
      return
    }

    Keychain.shared.removeAllKeys()
  }
}

// MARK: - reachability
extension AppDelegate {
  func startReachability() {
    try? reachability = Reachability()
    try? reachability?.startNotifier()
  }

  func reactionForNetwork() {
    Reachability.rx.isDisconnected
      .subscribe(onNext: {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        guard let topViewController = UIApplication.shared.keyWindowPresentedController else {
          return
        }
        topViewController.present(vc, animated: true)

      })
      .disposed(by: disposeBag)
  }
}
