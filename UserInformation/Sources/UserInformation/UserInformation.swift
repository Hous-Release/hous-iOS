
import Foundation

public struct UserInformation {
  public static var shared = UserInformation()
  private init() {}
  private let user = UserDefaults.standard
  private let isInitialUserKey = "isInitialUserKey"

  public var isInitialUser: Bool? {
    get {
      return user.value(forKey: isInitialUserKey) as? Bool
    }
    set {
      return user.setValue(newValue, forKey: isInitialUserKey)
    }
  }
  public func removeUserInformation() {
    user.removeObject(forKey: isInitialUserKey)
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

