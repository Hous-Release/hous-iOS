
import Foundation

public struct UserInformation {
  public static var shared = UserInformation()
  private init() {}
  private let user = UserDefaults.standard
  private let isOnboardingFlowKey = "isOnboardingFlowKey"

  public var isAlreadyOnboarding: Bool? {
    get {
      return user.value(forKey: isOnboardingFlowKey) as? Bool
    }
    set {
      return user.setValue(newValue, forKey: isOnboardingFlowKey)
    }
  }
  public func removeUserInformation() {
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

