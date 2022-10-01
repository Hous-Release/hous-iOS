//
//  UserDefault.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/10/01.
//


import Foundation

struct UserInformation {
  static var shared = UserInformation()
  private init() {}
  private let user = UserDefaults.standard
  private let isOnboardingFlowKey = "isOnboardingFlowKey"

  var isOnboardingFlow: Bool? {
    get {
      return user.value(forKey: isOnboardingFlowKey) as? Bool
    }
    set {
      return user.setValue(newValue, forKey: isOnboardingFlowKey)
    }
  }
  func removeUserInformation() {
    user.removeObject(forKey: isOnboardingFlowKey)
  }

  public static func isFirstLaunch() -> Bool {
    let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
    let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
    if isFirstLaunch {
      UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
      UserDefaults.standard.synchronize()
    }
    return isFirstLaunch
  }

}
