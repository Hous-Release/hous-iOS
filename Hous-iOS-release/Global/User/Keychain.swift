//
//  Keychain.swift
//  Hous-iOS-release
//
//  Created by 김호세 on 2022/09/23.
//


import SwiftKeychainWrapper

final class Keychain {

  static var shared = Keychain()
  private init() { }
  private let keychain: KeychainWrapper = KeychainWrapper.standard

  private let accessTokenKey = "accessTokenKey"
  private let refreshTokenKey = "refreshTokenKey"
  private let fcmTokenKey = "FCMTokenKey"
}

extension Keychain {
  public func setAccessToken(accessToken: String?) {
    self.keychain.removeObject(forKey: accessTokenKey)
    self.keychain.set(accessToken ?? "", forKey: accessTokenKey)
  }
  public func setRefreshToken(refreshToken: String?) {
    self.keychain.removeObject(forKey: refreshTokenKey)
    self.keychain.set(refreshToken ?? "", forKey: refreshTokenKey)
  }

  public func setFCMToken(fcmToken: String) {
    self.keychain.set(fcmToken, forKey: fcmTokenKey)
  }

  // MARK: -

  public func getAccessToken() -> String? {
    return self.keychain.string(forKey: accessTokenKey)
  }

  public func getRefreshToken() -> String? {
    return self.keychain.string(forKey: refreshTokenKey)
  }

  public func getFCMToken() -> String? {
    return self.keychain.string(forKey: fcmTokenKey)
  }

  public func removeAllKeys() {
    self.keychain.removeAllKeys()
  }
}
